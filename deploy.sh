#!/bin/bash
# create the canisters on the local network
NETWORK="local"


# dfx canister create frontend --network "${NETWORK}"
# dfx canister create backend --network "${NETWORK}"

dfx identity use testID
MINTERID="$(dfx identity get-principal)"
echo $MINTERID

PRINCIPAL="$(dfx identity get-principal)"
echo $PRINCIPAL

## store the principal id of the cli user
dfx identity use testID

export MINTER_ACCOUNT_ID=$(dfx ledger account-id)

export DEFAULT_ACCOUNT_ID=$(dfx ledger account-id)

export FEATURE_FLAGS=true

## deploy the chat ledger canister
echo "Step 2: deploying ICP_ledger  canister..."
dfx deploy  ICP_ledger --specified-id ryjl3-tyaaa-aaaaa-aaaba-cai --argument "
  (variant {
    Init = record {
      minting_account = \"$MINTER_ACCOUNT_ID\";
     feature_flags = opt record{icrc2 = true};
      initial_values = vec {
        record {
          \"$DEFAULT_ACCOUNT_ID\";
          record {
            e8s = 10_000_000_000 : nat64;
          };
        };
      };
      send_whitelist = vec {};
      transfer_fee = opt record {
        e8s = 10_000 : nat64;
      };
      token_symbol = opt \"ICP\";
      token_name = opt \"Local ICP\";
    }
  })
" --mode=reinstall -y


## deploy the chat ledger canister
echo "Step 3: deploying CkUSDC_ledger  canister..."
dfx deploy --network "${NETWORK}" CkUSDC_ledger --specified-id xevnm-gaaaa-aaaar-qafnq-cai --argument '
  (variant {
    Init = record {
      token_name = "Testnet ckUSDC";
      token_symbol = "ckUSDC";
      minting_account = record { owner = principal "'${MINTERID}'";};
     feature_flags = opt record{icrc2 = '${FEATURE_FLAGS}'};
      initial_balances = vec { record { record { owner = principal "'${MINTERID}'";}; 100_000_000_000; }; };
      metadata = vec {};
      transfer_fee = 10;
      archive_options = record {
        trigger_threshold = 2000;
        num_blocks_to_archive = 1000;
        controller_id = principal "'${PRINCIPAL}'";
      }
    }
  })
' --mode=reinstall -y

# deploy the backend canister
echo "Deploying the backend canister"
dfx deploy backend  --argument "br5f7-7uaaa-aaaaa-qaaca-cai"


#change the identity to default identity
dfx identity use default
export DPRINCIPAL=$(dfx identity get-principal)

dfx identity use testID
#transfer some coins to the default identity
dfx canister  call ICP_ledger icrc1_transfer '
  (record {
    to=(record {
      owner=(principal "'${DPRINCIPAL}'");
    });
    amount=10_00_000_000
  })
'

dfx canister  call CkUSDC_ledger icrc1_transfer '
  (record {
    to=(record {
      owner=(principal "'${DPRINCIPAL}'");
    });
    amount=10_00_000_000
  })
'

dfx identity use default

#exprting the backend canister id
export BACKEND=$(dfx canister id backend)
# approve the backend to transfer some icp
echo "approval of ICP"


dfx canister call ICP_ledger icrc2_approve "(record { 
  memo = null; 
  created_at_time=null;
  amount = 100000000;
  from_subaccount = null;
  expected_allowance = null;
  expires_at = null;
  spender = record { 
    owner = principal \"$BACKEND\";
    subaccount = null;
  };
  fee = null;
})"

echo "approval of ckUSDC"
dfx canister call CkUSDC_ledger icrc2_approve "(record { 
  memo = null; 
  created_at_time=null;
  amount = 100000000;
  from_subaccount = null;
  expected_allowance = null;
  expires_at = null;
  spender = record { 
    owner = principal \"$BACKEND\";
    subaccount = null;
  };
  fee = null;
})"

  #create a new invoice
  dfx canister call backend addNewInvoice '(
  record{
  address="kampala";
  email="smartskillsweb3@gmail.com";
  name="Samuel";
  },
  1734390000000,
  vec {
  },
  1700000,
  144444,
  variant{SOLANA},
  variant{SOL},

  )'