ID_FRONTEND=$(python3 -c "import json
with open('.dfx/local/canister_ids.json') as ids:
    print(json.load(ids).get('game_of_life_assets').get('local'))")

ID_BACKEND=$(python3 -c "import json
with open('.dfx/local/canister_ids.json') as ids:
    print(json.load(ids).get('game_of_life').get('local'))")



if [ $1 == "candid" ]; then
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
