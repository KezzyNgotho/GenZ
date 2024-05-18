// Types.mo
import Result "mo:base/Result";
import Trie "mo:base/Trie";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import List "mo:base/List";
import Principal "mo:base/Principal";


module {
    
   // Types.mo

public type Tokens = {
    amount_e8s: Nat;
};

public type TransferArgs = {
    to: Principal;
    amount: Tokens;
};

public type ProposalPayload = {
    canister_id: Principal;
    method: Text;
    message: Text;
};

public type Proposal = {
    id: Nat;
    timestamp: Int;
    proposer: Principal;
    payload: ProposalPayload;
    state: ProposalState;
    votes_yes: Tokens;
    votes_no: Tokens;
    voters: [Principal];
};

public type ProposalState = {
    #open;
    #accepted;
    #rejected;
    #executing;
    #succeeded;
    #failed: Text;
};

public type VoteArgs = {
    proposal_id: Nat;
    vote: Vote;
};

public type Vote = {
    #yes;
    #no;
};

public type SystemParams = {
    transfer_fee: Tokens;
    proposal_vote_threshold: Tokens;
    proposal_submission_deposit: Tokens;
};

public type BasicDaoStableStorage = {
    accounts: [(Principal, Tokens)];
    proposals: [(Nat, Proposal)];
    system_params: SystemParams;
};

public type Account = {
    owner: Principal;
    tokens: Tokens;
};

public let zeroToken: Tokens = { amount_e8s = 0 };

public func account_key(t: Principal): Trie.Key<Principal> = {
    key = t;
    hash = Principal.hash t;
};

public func proposal_key(id: Nat): Trie.Key<Nat> = {
    key = id;
    hash = Int.hash id;
};

public func accounts_fromArray(arr: [Account]): Trie.Trie<Principal, Tokens> {
    var s = Trie.empty<Principal, Tokens>();
    for (account in arr.vals()) {
        s := Trie.put(s, account_key(account.owner), Principal.equal, account.tokens).0;
    };
    s;
};

public func proposals_fromArray(arr: [Proposal]): Trie.Trie<Nat, Proposal> {
    var s = Trie.empty<Nat, Proposal>();
    for (proposal in arr.vals()) {
        s := Trie.put(s, proposal_key(proposal.id), Nat.equal, proposal).0;
    };
    s;
};

}
