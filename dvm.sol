pragma solidity ^0.4.20;

contract Stack {

    address     public  owner;
    uint256[]   public  stackInstructions;
    uint256     public  poppedInstruction;
    address[]   public  stackAddress;
    address     public  poppedAddress;
    bytes32[]   public  stackBytes32;
    bytes32     public  poppedBytes32;
    uint[]      public  stackUint;
    uint        public  poppedUint;
    bool[]      public  stackBool;
    bool        public  poppedBool;
    uint[]      public  stackJumps;
    uint256     public  poppedJump;
    uint256     public  instructionPointer;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function Stack() public {
        owner = msg.sender;
    }

    function GetStackUint() public constant returns (uint[]) {
        return stackUint;
    }

    function GetStackBytes32() public constant returns (bytes32[]) {
        return stackBytes32;
    }

    function GetStackAddress() public constant returns (address[]) {
        return stackAddress;
    }

    function GetStackInstructions() public constant returns (uint256[]) {
        return stackInstructions;
    }

    function GetStackBool() public constant returns (bool[]) {
        return stackBool;
    }

    function UintTail() public constant returns (uint) {
        if(stackUint.length >= 1) {
            return stackUint[stackUint.length-1];
        }
    }

    function Bytes32Tail() public constant returns (bytes32) {
        if(stackBytes32.length >= 1) {
            return stackBytes32[stackBytes32.length-1];
        }
    }

    function AddressTail() public constant returns (address) {
        if(stackAddress.length >= 1) {
            return stackAddress[stackAddress.length-1];
        }
    }

    function PushUint(uint _uint) onlyOwner public {
        stackUint.push(_uint);
    }

    function PushAddress(address _address) onlyOwner public {
        stackAddress.push(_address);
    }

    function PushBytes32(bytes32 _bytes32) onlyOwner public {
        stackBytes32.push(_bytes32);
    }
    function PushBool(bool _bool) public {
        stackBool.push(_bool);
    }

    function PushInstruction(uint8 _instruction) onlyOwner public {
        stackInstructions.push(_instruction);
    }

    function Pop(uint8 _typeof) onlyOwner public {
        if(_typeof == 10) { // 10 -> Pop instructions stack
            require(stackInstructions.length >= 1);
            poppedInstruction = stackInstructions[instructionPointer-1];
            stackInstructions.length--;
        } else if(_typeof == 11) { // 11 -> Pop stackAddress
            require(stackAddress.length >= 1);
            poppedAddress = stackAddress[instructionPointer-1];
            stackAddress.length--;
            instructionPointer--;
        } else if (_typeof == 12) { // 12 -> Pop stackBytes32
            require(stackBytes32.length >= 1);
            poppedBytes32 = stackBytes32[instructionPointer-1];
            stackBytes32.length--;
            instructionPointer--;
        } else if (_typeof == 13) { // 13 -> Pop stackUint
            require(stackUint.length >= 1);
            poppedUint = stackUint[instructionPointer-1];
            stackUint.length--;
        } else if (_typeof == 14) { // 14 -> Pop stackBool
            require(stackBool.length >= 1);
            poppedBool = stackBool[instructionPointer-1];
            stackBool.length--;
            instructionPointer--;
        } else if (_typeof == 15) { // 15 -> Pop stackJumps
            instructionPointer = stackInstructions[stackInstructions.length-1];
            stackJumps.length--;
        }
    }

    function SetStackInstructions(uint256[] _stackInstructions) onlyOwner public {
        stackInstructions  = _stackInstructions;
        instructionPointer = _stackInstructions.length;
    }

    function SetStackAddress(address[] _stackAddress) onlyOwner public {
        stackAddress = _stackAddress;
    }

    function SetStackBytes32(bytes32[] _stackBytes32) onlyOwner public {
        stackBytes32 = _stackBytes32;
    }

    function SetStackUint(uint[] _stackUint) onlyOwner public {
        stackUint = _stackUint;
    }

    function SetStackBool(bool[] _stackBool) onlyOwner public {
        stackBool = _stackBool;
    }

    function SetStackJump(uint[] _stackJump) onlyOwner public {
        stackJumps = _stackJump;
    }

    function Play() onlyOwner public {
        require(instructionPointer >= 1);
        Pop(10);
        if(poppedInstruction == 1) {
            // We are going to transfer poppedUint to poppedAddress
            Pop(13); // poppedUint
            Pop(11); // poppedAddress
            instructionPointer--;
            poppedAddress.transfer(poppedUint);
        } else if(poppedInstruction == 2) {
            // We are going to add Pop(13) and Pop(13);
            Pop(13);
            uint a = poppedUint;
            Pop(13);
            uint b = poppedUint;
            stackUint.push(a + b);
        } else if(poppedInstruction == 3) {
            Pop(13); // poppedUint
            uint _a = poppedUint;
            Pop(13); // poppedUint
            uint _b = poppedUint;
            stackUint.push(_a - _b);
        } else if(poppedInstruction == 4) {
            // After opcode 4 always do pop 15 to know where to go
            Pop(15); // poppedJump;
        }
    }
}
