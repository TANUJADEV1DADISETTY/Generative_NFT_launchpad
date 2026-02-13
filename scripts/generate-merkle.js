const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const fs = require("fs");

const allowlist = JSON.parse(fs.readFileSync("allowlist.json"));

const leaves = allowlist.map(addr => keccak256(addr));
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });

const root = tree.getHexRoot();

console.log("Merkle Root:", root);
