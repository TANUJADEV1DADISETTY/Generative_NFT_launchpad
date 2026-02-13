"use client";

import { useState, useEffect } from "react";
import { ethers } from "ethers";

const CONTRACT_ADDRESS = process.env.NEXT_PUBLIC_CONTRACT_ADDRESS!;

const ABI = [
  "function publicMint(uint256 quantity) payable",
  "function totalSupply() view returns (uint256)",
  "function MAX_SUPPLY() view returns (uint256)",
  "function saleState() view returns (uint8)"
];

export default function Home() {
  const [account, setAccount] = useState<string>();
  const [quantity, setQuantity] = useState(1);
  const [minted, setMinted] = useState("0");
  const [saleState, setSaleState] = useState("");

  const connect = async () => {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const accounts = await provider.send("eth_requestAccounts", []);
    setAccount(accounts[0]);
  };

  const mint = async () => {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);

    const tx = await contract.publicMint(quantity, {
      value: ethers.parseEther((0.01 * quantity).toString())
    });
    await tx.wait();
    fetchData();
  };

  const fetchData = async () => {
    const provider = new ethers.JsonRpcProvider(process.env.NEXT_PUBLIC_RPC_URL);
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, provider);

    const supply = await contract.totalSupply();
    const state = await contract.saleState();

    setMinted(supply.toString());
    setSaleState(state === 0 ? "Paused" : state === 1 ? "Allowlist" : "Public");
  };

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <div style={{ padding: 40 }}>
      {!account ? (
        <button data-testid="connect-wallet-button" onClick={connect}>
          Connect Wallet
        </button>
      ) : (
        <div data-testid="connected-address">{account}</div>
      )}

      <h3 data-testid="mint-count">{minted}</h3>
      <h3 data-testid="total-supply">10000</h3>
      <h3 data-testid="sale-status">{saleState}</h3>

      <input
        data-testid="quantity-input"
        type="number"
        value={quantity}
        onChange={(e) => setQuantity(Number(e.target.value))}
      />

      <button data-testid="mint-button" onClick={mint}>
        Mint
      </button>
    </div>
  );
}
