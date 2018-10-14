
pragma solidity ^0.4.24;
// We have to specify what version of compiler this code will compile with

contract resume_storage {

    mapping (address => bool) public isUser;
    mapping (address => bool) public isProvider;
    mapping (uint256 => mapping (address => Records)) records;
    mapping (uint256 => dateRange) dateRanges;
    mapping (address => mapping (string => uint256)) mappingByPublicKey;

    uint constant public MAX_COUNT = 50;
    uint256 public recordCount = 0;


    struct Records {
        bool providedName;
        string name;
        address user;
        address provider;
        uint256 startDate;
        uint256 endDate;
        uint256 description;
    }

    struct dateRange {
        uint256 startDate;
        uint256 endDate;
    }
    
    modifier onlyUser(uint256 recordId) {
        require(records[recordId][msg.sender].user == msg.sender);
        _;
    }

    modifier onlyProvider(uint256 recordId, address _userPublicAddress) {
        require(records[recordId][_userPublicAddress].provider == msg.sender);
        _;
    }
    
    modifier validParameters(uint count) {
        require(count <= MAX_COUNT && count != 0);
        _;
    }
    
    modifier providerDoesNotExist(address provider) {
        require(!isProvider[provider]);
        _;
    }

    modifier providerExist(address provider) {
        require(isProvider[provider]);
        _;
    }

    modifier userDoesNotExist(address user) {
        require(!isUser[user]);
        _;
    }

    modifier userExist(address user) {
        require(isUser[user]);
        _;
    }

    modifier notNull(address _address) {
        require(_address != 0);
        _;
    }

    modifier notEmpty(string name) {
        bytes memory tempString = bytes(name);
        require(tempString.length != 0);
        _;
    }
    
    modifier recordExists(uint256 recordId, address _userPublicAddress) {
        address _provider = records[recordId][_userPublicAddress].provider;
        require(_provider != 0x0);
        _;
    }
    
    
    function addRecord (
        address _userPublicAddress,
        address _provider,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _description)
        public
        userExist(_userPublicAddress)
        providerExist(_provider)
    {
        records[recordCount][_userPublicAddress].providedName = false;
        records[recordCount][_userPublicAddress].user = _userPublicAddress;
        records[recordCount][_userPublicAddress].provider = _provider;
        records[recordCount][_userPublicAddress].startDate = _startDate;
        records[recordCount][_userPublicAddress].endDate = _endDate;
        records[recordCount][_userPublicAddress].description = _description;

        dateRanges[recordCount].startDate = _startDate;
        dateRanges[recordCount].endDate = _endDate;

        recordCount += 1;
    }

    function addUser(address _userPublicAddress)
        public
        userDoesNotExist(_userPublicAddress)
    {
        isUser[_userPublicAddress] = true;
    }


    function getRecord(uint _recordID, address _userPublicAddress)
        public
        recordExists(_recordID, _userPublicAddress)
        view
        returns (
            address _user,
            address _provider,
            uint256 _startDate,
            uint256 _endDate,
            uint256 _description
        )
    {
        _user = records[_recordID][_userPublicAddress].user;
        _provider = records[_recordID][_userPublicAddress].provider;
        _startDate = records[_recordID][_userPublicAddress].startDate;
        _endDate = records[_recordID][_userPublicAddress].endDate;
        _description = records[_recordID][_userPublicAddress].description;
    }

    function addProvider(address _provider)
        public
        providerDoesNotExist(_provider)
        userDoesNotExist(_provider)
        notNull(_provider)
    {
        isProvider[_provider] = true;
    }
}