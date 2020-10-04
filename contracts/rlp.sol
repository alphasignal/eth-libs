pragma solidity ^0.5.0;

contract Rlp {

    uint256 constant ADDRESS_BYTES = 20;
    uint256 constant MAX_SINGLE_BYTE = 128;
    uint256 constant MAX_NONCE = 256**9 - 1;

/*
	function mk_contract_address(uint _nonce) pure internal returns(address rlp) {
		if(_nonce == 0x00)     return address(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(this), byte(0x80)))));
		if(_nonce <= 0x7f)     return address(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(this), uint8(_nonce)))));
		if(_nonce <= 0xff)     return address(uint256(keccak256(abi.encodePacked(byte(0xd7), byte(0x94), address(this), byte(0x81), uint8(_nonce)))));
		if(_nonce <= 0xffff)   return address(uint256(keccak256(abi.encodePacked(byte(0xd8), byte(0x94), address(this), byte(0x82), uint16(_nonce)))));
		if(_nonce <= 0xffffff) return address(uint256(keccak256(abi.encodePacked(byte(0xd9), byte(0x94), address(this), byte(0x83), uint24(_nonce)))));
		return address(uint256(keccak256(abi.encodePacked(byte(0xda), byte(0x94), address(this), byte(0x84), uint32(_nonce))))); // more than 2^32 nonces not realistic
	}
*/
    function mk_contract_address(address a, uint256 n) pure internal returns (address rlp) {
        /*
         * make sure the RLP encoding fits in one word:
         * total_length      1 byte
         * address_length    1 byte
         * address          20 bytes
         * nonce_length      1 byte (or 0)
         * nonce           1-9 bytes
         *                ==========
         *                24-32 bytes
         */
        require(n <= MAX_NONCE);

        // number of bytes required to write down the nonce
        uint256 nonce_bytes;
        // length in bytes of the RLP encoding of the nonce
        uint256 nonce_rlp_len;

        if (0 < n && n < MAX_SINGLE_BYTE) {
            // nonce fits in a single byte
            // RLP(nonce) = nonce
            nonce_bytes = 1;
            nonce_rlp_len = 1;
        } else {
            // RLP(nonce) = [num_bytes_in_nonce nonce]
            nonce_bytes = count_bytes(n);
            nonce_rlp_len = nonce_bytes + 1;
        }

        // [address_length(1) address(20) nonce_length(0 or 1) nonce(1-9)]
        uint256 tot_bytes = 1 + ADDRESS_BYTES + nonce_rlp_len;

        // concatenate all parts of the RLP encoding in the leading bytes of
        // one 32-byte word
        uint256 word = ((192 + tot_bytes) * 256**31) +
                       ((128 + ADDRESS_BYTES) * 256**30) +
                       (uint256(a) * 256**10);

        if (0 < n && n < MAX_SINGLE_BYTE) {
            word += n * 256**9;
        } else {
            word += (128 + nonce_bytes) * 256**9;
            word += n * 256**(9 - nonce_bytes);
        }

        uint256 hash;

        assembly {
            let mem_start := mload(0x40)        // get a pointer to free memory
            mstore(mem_start, word)             // store the rlp encoding
            hash := sha3(mem_start,
                         add(tot_bytes, 1))     // hash the rlp encoding
        }

        // interpret hash as address (20 least significant bytes)
        return address(hash);
    }
}