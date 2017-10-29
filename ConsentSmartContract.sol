pragma solidity ^0.4.0;

/// @title Giving consent
contract Consent {

    struct Consenter {
      bool consent;
      bool permanentNo;
      address partner;
    }

    event UpdateConsentStatus(string _msg, bool _consent);

    mapping(address => Consenter) public consenters;

    //Create a contract and set the consent variable to false
    //also set your partner to the address given
    function createContract() public {
        string eventMsg = " Does not give Consent ";
        if (consent && !permanentNo) {
            eventMsg = " Gives Consent ";
        }
        consenters[msg.sender].consent = 0;
    }


    //set the current partner to who you are touching phones to and give
    //consent
    function giveConsent(address partner) public {
      Consenter storage sender = consenters[msg.sender];
      if(sender.permanentNo != 1){
        sender.consent = 1;
      }
      sender.partner = partner;
    }

    //This function means that the person has decided that they do not want to
    //engage
    function setPermanentNo(bool permNo) public {
      Consenter storage sender = consenters[msg.sender];
      sender.permanentNo = 1;
    }

    function takeBackConsent() public {
      Consenter storage sender = consenters[msg.sender];
      sender.consent = 0;
    }

    function changePartner(address partner) public {
      Consenter storage sender = consenters[msg.sender];
      sender.partner = partner;
    }

}
