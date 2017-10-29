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

    //This is pretty much the only function we need for now, it creates the
    //contract and then sets the consent bool as well as your partner

    function createContract(bool consent, address partner) public {
      string eventMsg = " Does not give Consent ";
      if (consent) {
          eventMsg = " Gives Consent ";
      }
      consenters[msg.sender].consent = consent;
      consenters[msg.sender].partner = partner;
    }


    //Create a contract and set the consent variable to false
    //also set your partner to the address given
    function createContractEmpty() public {
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
      sender.consent = 1;
      sender.partner = partner;
    }


    //remove your consent
    function takeBackConsent() public {
      Consenter storage sender = consenters[msg.sender];
      sender.consent = 0;
    }


    //looks like you are changing partners
    function changePartner(address partner) public {
      Consenter storage sender = consenters[msg.sender];
      sender.partner = partner;
    }

}
