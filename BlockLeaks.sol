pragma solidity ^0.4.0;

/*
 - 위키 리크스 같은 폭로 게시판
    - 등록시 이더를 0.0001 이상 올려야 함
    - 글을 삭제하면 돈을...
 - 블록체인상에 올라가며, 사실임을 입증하기 위해 이더를 맡겨둬야 한다
 - 만약 사실이 아니다 싶으면 
*/

contract BlockLeaks {
    struct Confession {
        string content;
        uint8 upvote;
        uint8 downvote;
        address writer;
        uint etherValue;
    }

    uint public startTime;

    event ReservedToken(address sender, uint etherValue);
    event NewContentsAdded(address writer, string content, uint etherValue);

    address adminAddress;
    Confession[] public confessions;

    /// Create a new ballot with $(_numProposals) different proposals.
    function BlockLeaks() public {
        adminAddress = msg.sender;
        startTime = now;
    }

    /// Give a single vote to proposal $(toProposal).
    function write(string _content) public payable {
        confessions.push(Confession({
            content: _content,
            writer: msg.sender,
            upvote: 0,
            downvote: 0,
            etherValue: msg.value
        }));
        NewContentsAdded(msg.sender, _content, msg.value);
    }

    function getContentsLength() public constant returns(uint) {
        return confessions.length;
    }

    function () payable {
        ReservedToken(msg.sender, msg.value);
    }

    function getContents(uint idx) public constant returns(
                        string)
                        {
        if (idx >= confessions.length) 
            return "";

        return confessions[idx].content;
    }

    function deleteContent(uint idx) public {
        if (confessions[idx].writer == msg.sender) {
            confessions[idx].content = "삭제됨";
            confessions[idx].writer.transfer((confessions[idx].etherValue*100)/110);
            // confessions[idx].writer.transfer(1);
        }
    }

    /*
     - 글 쓸 때 돈을 내도록 해야한다 => 이더를 최소 0.001 (천원) 이상 내야만 기록이 되고.. 돈을 빼기 위해서는 
       -> 글 쓸때 시간을 기록하고,...
     - 이벤트 기록을 어디서 살펴보나?
     - IPFS 기록은 어떻게 하나?
    */

    // function winningProposal() public constant returns (uint8 _winningProposal) {
    //     uint256 winningVoteCount = 0;
    //     for (uint8 prop = 0; prop < proposals.length; prop++)
    //         if (proposals[prop].voteCount > winningVoteCount) {
    //             winningVoteCount = proposals[prop].voteCount;
    //             _winningProposal = prop;
    //         }
    // }
}