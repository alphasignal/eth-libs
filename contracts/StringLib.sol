pragma solidity <=0.8.26;

contract StringLib
{
    function uint2str(uint i) public pure returns (string memory)
    {
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0){
            bstr[k--] = bytes1(uint8(48 + i % 10));
            i /= 10;
        }
        return string(bstr);
    }

    function append(string calldata a, string calldata b) external pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }    
    function append(string calldata a, string calldata b, string calldata c) external pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }    
    function append(string calldata a, string calldata b, string calldata c, string calldata d) external pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d));
    }    
    function append(string calldata a, string calldata b, string calldata c, string calldata d, string calldata e) external pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e));
    }    
    function append(string calldata a, string calldata b, string calldata c, string calldata d, string calldata e, string calldata f) external pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e, f));
    }    
    function append(string calldata a, string calldata b, string calldata c, string calldata d, string calldata e, string calldata f, string calldata g) external pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e, f, g));
    }    

    function geHashFromString(string calldata _name) external pure returns(uint) {
        return uint(keccak256(bytes(_name)));
    }
}
