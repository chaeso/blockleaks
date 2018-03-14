pragma solidity ^0.4.0;

/*
 - 연예인 사진 수집
    - 일단 처음엔 5명으로 시작하자
- WEB
    - 연예인 목록 불러오는 페이지
    - 게시판 보기 기능
    - 게시판 구매 기능 (ver 2)
    - 게시판 글쓰기 기능
- Smart Contract
    - 연예인 목록 불러오는 함수
    - 각 연예인 별 게시판 목록 (좌표,...)
        - (x좌표, y좌표, 편지글, 작성자)
    - 연예인 추가 함수 (이름, 이미지 주소, Popularity=0, owner=null)
- 목표
    - https://dappradar.com/ 여기에 올리고 5등 안에 드는 것
- 경제
    - 연예인의 게시판을 구매 가능 (소유권 이전 가능)
    - 게시판에 글쓰면 이더는 게시판 주인에게...
*/

contract CryptoCelebLetter {
    struct Celeb {
        string name;
        string imgurl;
        address owner;
        uint price;
        uint invested;
    }

    struct Board {
        string memo;
        uint x;
        uint y;
        address writer;
        string writerName;  // 공순이
        uint price;
    }

    uint public startTime;

    event ReservedToken(address sender, uint etherValue);
    event NewContentsAdded(address writer, string content, uint etherValue);

    address adminAddress;
    Celeb[] public celebs;
    mapping (string => Board[]) boards;

    modifier ownerOnly()
    {
        require(msg.sender == adminAddress);
        _;
    }
    
    function CryptoCelebLetter() public {
        adminAddress = msg.sender;
        startTime = now;
    }

    function registerCeleb(string _name, string _imgurl, uint _price) ownerOnly {
        celebs.push(Celeb({
            name: _name,
            imgurl: _imgurl,
            price: _price,
            owner: msg.sender,
            invested: 0
        }));
    }

    /// Give a single vote to proposal $(toProposal).
    function write(string _name, string _memo, uint _x, uint _y, string _writerName) public payable {
        boards[_name].push(Board({
            memo: _memo,
            x: _x,
            y: _y,
            writer: msg.sender,
            writerName: _writerName,
            price: msg.value
        }));
    }

    function getCelebsCount() public constant returns(uint) {
        return celebs.length;
    }

    function getBoardsCount(string _name) public constant returns(uint) {
        return boards[_name].length;
    }

    function () payable {
        ReservedToken(msg.sender, msg.value);
    }

    function getCeleb(uint idx) public constant returns(string, string, address, uint, uint) {
        if (idx >= celebs.length)
            return ("", "", msg.sender, 0, 0);

        return (celebs[idx].name, celebs[idx].imgurl, celebs[idx].owner, celebs[idx].price, celebs[idx].invested);
    }

    function getBoard(string _name, uint idx) public constant returns(string, uint, uint, address, string, uint) {
        if (idx >= boards[_name].length)
            return ("", 0, 0, msg.sender, "", 0);

        return (boards[_name][idx].memo, boards[_name][idx].x, boards[_name][idx].y, boards[_name][idx].writer, boards[_name][idx].writerName, boards[_name][idx].price);
    }
}