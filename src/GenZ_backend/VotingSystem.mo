// VotingSystem.mo

import Types "Types";
import Trie "mo:base/Trie";
import Nat "mo:base/Nat";

module{

actor class VotingSystem() {
    stable var proposals: Trie.Trie<Nat, Types.Proposal> = Trie.empty();

    public func createProposal(proposal: Types.Proposal): async Types.Proposal {
        proposals := Trie.put(proposals, proposal.id, proposal).0;
        return proposal;
    };

    public func getProposal(id: Nat): async ?Types.Proposal {
        return Trie.get(proposals, id);
    };

    public func vote(args: Types.VoteArgs, voter: Principal, weight: Nat): async ?Types.Proposal {
        let proposalOpt = Trie.get(proposals, args.proposal_id);
        switch proposalOpt {
            case (?proposal) {
                if (!List.contains(proposal.voters, voter)) {
                    let updatedProposal = switch (args.vote) {
                        case (#yes) { { proposal with votes_yes = { amount_e8s = proposal.votes_yes.amount_e8s + weight } }; };
                        case (#no) { { proposal with votes_no = { amount_e8s = proposal.votes_no.amount_e8s + weight } }; };
                    };
                    updatedProposal.voters := [voter] #@ updatedProposal.voters;
                    proposals := Trie.put(proposals, args.proposal_id, updatedProposal).0;
                    return ?updatedProposal;
                };
                return null;
            };
            case null { return null; };
        }
    };

    public func getAllProposals(): async [Types.Proposal] {
        return Trie.toList(proposals).vals();
    };
}
}