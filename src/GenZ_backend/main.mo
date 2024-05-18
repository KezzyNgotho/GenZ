// main.mo

import TokenCanister "TokenCanister";
import ICRC1 "ICRC1";
import Types "Types";
import VotingSystem "VotingSystem";
import Principal "mo:base/Principal";
import Option "mo:base/Option";



actor Main {
    // Initialize the token canister
    stable var tokenCanister: ?TokenCanister = null;
    stable var votingSystem: VotingSystem = VotingSystem();

    public func initializeToken(initialSupply: ICRC1.Balance, initialOwner: Principal): async Text {
        if (Option.isSome(tokenCanister)) {
            return "Token has already been initialized.";
        } else {
            tokenCanister := ?TokenCanister(initialSupply, initialOwner);
            return "Token initialized successfully.";
        }
    };

    public func getToken(): async ?ICRC1.Token {
        switch (tokenCanister) {
            case (?canister) { return ?await? canister.token(); };
            case (null) { return null; };
        }
    };

    public func getBalance(account: ICRC1.Account): async ?ICRC1.Balance {
        switch (tokenCanister) {
            case (?canister) { return ?await? canister.balanceOf(account); };
            case (null) { return null; };
        }
    };

    public func transfer(args: ICRC1.TransferArgs): async ?ICRC1.TransferResult {
        switch (tokenCanister) {
            case (?canister) { return ?await? canister.transfer(args); };
            case (null) { return null; };
        }
    };

    public func mint(recipient: ICRC1.Account, amount: ICRC1.Balance): async ?ICRC1.Balance {
        switch (tokenCanister) {
            case (?canister) { return ?await? canister.mint(recipient, amount); };
            case (null) { return null; };
        }
    };

    public func burn(owner: ICRC1.Account, amount: ICRC1.Balance): async ?ICRC1.Balance {
        switch (tokenCanister) {
            case (?canister) { return ?await? canister.burn(owner, amount); };
            case (null) { return null; };
        }
    };

    // Voting system functions
    public func createProposal(proposal: Types.Proposal): async Types.Proposal {
        return await? votingSystem.createProposal(proposal);
    };

    public func getProposal(id: Nat): async ?Types.Proposal {
        return await? votingSystem.getProposal(id);
    };

    public func vote(args: Types.VoteArgs, voter: Principal, weight: Nat): async ?Types.Proposal {
        return await? votingSystem.vote(args, voter, weight);
    };

    public func getAllProposals(): async [Types.Proposal] {
        return await? votingSystem.getAllProposals();
    };
}
