// ICRC1.mo
module{
public type Balance = Nat;
public type SubAccount = Blob;

public type Account = {
    owner: Principal;
    subaccount: ?SubAccount;
};

public type Token = {
    totalSupply: Balance;
    name: Text;
    symbol: Text;
    decimals: Nat8;
};

public type TransferArgs = {
    from: Account;
    to: Account;
    amount: Balance;
};

public type TransferResult = {
    #ok: Balance;
    #err: TransferError;
};

public type TransferError = {
    #insufficientBalance;
    #invalidAccount;
    #other: Text;
};

public type ICRC1 = {
    token: () -> async Token;
    balanceOf: (Account) -> async Balance;
    transfer: (TransferArgs) -> async TransferResult;
};
}