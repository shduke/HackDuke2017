pragma solidity ^0.4.0;

/// @title Giving consent
contract Consent {

    struct Consenter {
      bool consent;
    }

    event UpdateConsentStatus(string _msg, bool _consent);

    mapping(address => Consenter) public consenters;

    //This is pretty much the only function we need for now, it creates the
    //contract and then sets the consent bool as well as your partner

    function initiateConsent(bool consent) public {
      string eventMsg = " Does not give Consent ";
      if (consent) {
          eventMsg = " Gives Consent ";
      }
      consenters[msg.sender].consent = consent;
      consenters[msg.sender].partner = partner;
    }

}
