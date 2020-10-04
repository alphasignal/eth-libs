pragma solidity ^0.5.0;

contract Rlp {


	function mk_contract_address(uint _nonce) view internal returns(address rlp) {
		if(_nonce == 0x00)     return address(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(this), byte(0x80)))));
		if(_nonce <= 0x7f)     return address(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(this), uint8(_nonce)))));
		if(_nonce <= 0xff)     return address(uint256(keccak256(abi.encodePacked(byte(0xd7), byte(0x94), address(this), byte(0x81), uint8(_nonce)))));
		if(_nonce <= 0xffff)   return address(uint256(keccak256(abi.encodePacked(byte(0xd8), byte(0x94), address(this), byte(0x82), uint16(_nonce)))));
		if(_nonce <= 0xffffff) return address(uint256(keccak256(abi.encodePacked(byte(0xd9), byte(0x94), address(this), byte(0x83), uint24(_nonce)))));
		return address(uint256(keccak256(abi.encodePacked(byte(0xda), byte(0x94), address(this), byte(0x84), uint32(_nonce))))); // more than 2^32 nonces not realistic
	}

}