ID_FRONTEND=$(dfx canister id game_of_life_assets)

ID_BACKEND=$(dfx canister id game_of_life)

if [ "$1" == "candid" ]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "http://127.0.0.1:8000/candid?canisterId=$ID_BACKEND"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        open "http://127.0.0.1:8000/candid?canisterId=$ID_BACKEND"
    fi
else
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "http://127.0.0.1:8000/?canisterId=$ID_FRONTEND"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        open "http://127.0.0.1:8000/?canisterId=$ID_FRONTEND"
    fi
fi
