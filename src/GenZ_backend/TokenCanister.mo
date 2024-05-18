// TokenCanister.mo

import ICRC1 "ICRC1";
import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Option "mo:base/Option";
module{

actor class TokenCanister(initialSupply: ICRC1.Balance, initialOwner: Principal) {

    // Token state
    stable var totalSupply: ICRC1.Balance = initialSupply;
    stable var balances: Trie.Trie<ICRC1.Account, ICRC1.Balance> = {
        let initBalances = Trie.empty<ICRC1.Account, ICRC1.Balance>();
        Trie.put(initBalances, { owner = initialOwner; subaccount = null }, initialSupply).0;
    };

    // Token metadata
    stable let name: Text = "GenZToken";
    stable let symbol: Text = "GENZ";
    stable let decimals: Nat8 = 8;

    public func token(): async ICRC1.Token {
        return {
            totalSupply = totalSupply;
            name = name;
            symbol = symbol;
            decimals = decimals;
        };
    };

    public func balanceOf(account: ICRC1.Account): async ICRC1.Balance {
        return Option.get(Trie.get(balances, account), 0);
    };

    public func transfer(args: ICRC1.TransferArgs): async ICRC1.TransferResult {
        let fromBalance = Option.get(Trie.get(balances, args.from), 0);
        if (fromBalance < args.amount) {
            return #err(#insufficientBalance);
        };

        let toBalance = Option.get(Trie.get(balances, args.to), 0);

        balances := Trie.put(balances, args.from, fromBalance - args.amount).0;
        balances := Trie.put(balances, args.to, toBalance + args.amount).0;

        return #ok(args.amount);
    };

    // Minting functionality
    public func mint(recipient: ICRC1.Account, amount: ICRC1.Balance): async ICRC1.Balance {
        let recipientBalance = Option.get(Trie.get(balances, recipient), 0);
        let newRecipientBalance = recipientBalance + amount;

        totalSupply += amount;
        balances := Trie.put(balances, recipient, newRecipientBalance).0;

        return newRecipientBalance;
    };

    // Burning functionality
    public func burn(owner: ICRC1.Account, amount: ICRC1.Balance): async ICRC1.Balance {
        let ownerBalance = Option.get(Trie.get(balances, owner), 0);
        if (ownerBalance < amount) {
            return 0;
        };

        let newOwnerBalance = ownerBalance - amount;
        totalSupply -= amount;

        balances := Trie.put(balances, owner, newOwnerBalance).0;

        return newOwnerBalance;
    };
}
}