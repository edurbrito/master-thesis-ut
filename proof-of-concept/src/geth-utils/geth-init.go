package main

import (
	"flag"
	"fmt"
	"net"
	"os"
	"os/exec"
	"regexp"
	"sort"
	"strings"
)

const (
	hexCharsRegex = "[0-9a-fA-F]{40}"
)

func GetInterfaceIpv4Addr(interfaceName string) (addr string, err error) {
	var (
		iface    *net.Interface
		addrs    []net.Addr
		ipv4Addr net.IP
	)
	if iface, err = net.InterfaceByName(interfaceName); err != nil { // get interface
		return
	}
	if addrs, err = iface.Addrs(); err != nil { // get addresses
		return
	}
	for _, addr := range addrs { // get ipv4 address
		if ipv4Addr = addr.(*net.IPNet).IP.To4(); ipv4Addr != nil {
			break
		}
	}
	if ipv4Addr == nil {
		return "", fmt.Errorf("no ipv4 address found for interface %s", interfaceName)
	}
	return ipv4Addr.String(), nil
}

func main() {
	signersFlag := flag.String("signers", "", "comma-separated list of signer addresses")

	flag.Parse()

	// get the account address from the self node
	// list the files in the keystore directory
	files, err := os.ReadDir("/root/.ethereum/keystore")
	if err != nil || len(files) == 0 {
		fmt.Println("Error reading keystore directory:", err)
		return
	}

	// get the first file in the keystore directory
	fileName := files[0].Name()

	// get the account address from the file name
	// the address comes after the last two dashes in the file name
	// UTC--2023-03-20T08-37-47.753790440Z--0311885597e5eaa5e9b06e70a4e50e663c3d8396
	// 0311885597e5eaa5e9b06e70a4e50e663c3d8396
	accountAddress := strings.Split(fileName, "--")[2]

	signers := []string{accountAddress}

	if *signersFlag != "" {
		signers = append(signers, strings.Split(*signersFlag, ",")...)

		fmt.Println("Parsing signers...")

		for _, signer := range signers {
			signerLen := len(signer)
			matched, _ := regexp.MatchString(hexCharsRegex, signer)
			if signerLen != 40 || !matched {
				fmt.Printf("Error: invalid signer address '%s'\n", signer)
				return
			}
		}
	}

	// sort the signers
	sort.Strings(signers)

	fmt.Println("Success!")
	fmt.Println("Signers:", signers)

	fmt.Println("Writing genesis.json...")

	// write genesis.json with signers in extraData
	// Open the file for writing, creating it if it doesn't exist
	file, err := os.OpenFile("/root/.ethereum/genesis.json", os.O_WRONLY|os.O_CREATE, 0644)

	if err != nil {
		fmt.Println("Error genesis.json opening file:", err)
		return
	}

	defer file.Close()

	// Write a formatted string to the file
	genesis := `{
		"config": {
		  "chainId": 11,
		  "homesteadBlock": 0,
		  "eip150Block": 0,
		  "eip155Block": 0,
		  "eip158Block": 0,
		  "byzantiumBlock": 0,
		  "constantinopleBlock": 0,
		  "petersburgBlock": 0,
		  "istanbulBlock": 0,
		  "muirGlacierBlock": 0,
		  "berlinBlock": 0,
		  "londonBlock": 0,
		  "arrowGlacierBlock": 0,
		  "grayGlacierBlock": 0,
		  "clique": {
			"period": 1,
			"epoch": 30000
		  }
		},
		"difficulty": "1",
		"gasLimit": "800000000",
		"extradata": "0x0000000000000000000000000000000000000000000000000000000000000000%s0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		"alloc": {
			"0x0000000000000000000000000000000000000011": {
				"balance": "0x0",
				"code": "0x608060405234801561001057600080fd5b506101bf806100206000396000f3fe608060405234801561001057600080fd5b506004361061002b5760003560e01c8063d7708adc14610030575b600080fd5b61004a600480360381019061004591906100b9565b610060565b6040516100579190610101565b60405180910390f35b6000806001436100709190610155565b409050828114915050919050565b600080fd5b6000819050919050565b61009681610083565b81146100a157600080fd5b50565b6000813590506100b38161008d565b92915050565b6000602082840312156100cf576100ce61007e565b5b60006100dd848285016100a4565b91505092915050565b60008115159050919050565b6100fb816100e6565b82525050565b600060208201905061011660008301846100f2565b92915050565b6000819050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60006101608261011c565b915061016b8361011c565b925082820390508181111561018357610182610126565b5b9291505056fea26469706673582212207b04b6d75d74cf1f7ec4f0bdc6568552be797968cf7ec31db04df0d5e43eff9d64736f6c63430008120033"
			}
		}
	}`

	// concatenate all signers into one string
	signersString := strings.Join(signers, "")

	_, err = fmt.Fprintf(file, genesis, signersString)
	if err != nil {
		fmt.Println("Error writing to genesis.json file:", err)
		return
	}

	fmt.Println("Running geth init...")

	// initialize geth with genesis.json
	// running geth --nousb --datadir /root/.ethereum init /root/.ethereum/genesis.json
	cmd := exec.Command("geth", "--nousb", "--datadir", "/root/.ethereum", "init", "/root/.ethereum/genesis.json")
	_, err = cmd.Output()
	if err != nil {
		fmt.Println("Error running command:", err)
		return
	}
}
