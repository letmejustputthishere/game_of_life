# Game of Life


To learn more before you start working with game_of_life, see the following documentation available online:

- [Quick Start](https://sdk.dfinity.org/developers-guide/quickstart.html)
- [Developer's Guide](https://sdk.dfinity.org/developers-guide)
- [Language Reference](https://sdk.dfinity.org/language-guide)

If you want to start working on your project right away, you might want to try the following commands:

```bash
cd game_of_life/
dfx help
dfx config --help
```

### Demo

If you have access to the Tungsten Developer Network, this canister is available under https://7ifp6-zqcaa-aaaaa-aaaaa-caaaa-aaaaa-aaaaa-q.ic0.app/ for you to play around with. If not, follow the steps below.

Install the required Node modules (only needed the first time).

```bash
npm install
```

Start the replica, then build and install the canisters.

```bash
dfx start --background
dfx canister create --all
dfx build
dfx canister install --all
```

Open the canister frontend in your web browser.
You can either run the provided `start.sh` shellscript when on macOS our linux
(you might need to edit the file with 'chmod +x start.sh' to be able to execute it)

```bash
./start.sh
```
or you run the same steps manually

```bash
ID=$(python3 -c "import json
with open('.dfx/local/canister_ids.json') as ids:
    print(json.load(ids).get('game_of_life_assets').get('local'))")

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
xdg-open "http://127.0.0.1:8000/?canisterId=$ID"
elif [[ "$OSTYPE" == "darwin"* ]]; then
open "http://127.0.0.1:8000/?canisterId=$ID"
fi
```
It is also possible to use `start.sh` with the  `candid` argument to view the candid interface for the backend

```bash
./start.sh candid
```

or run the same steps manually

```bash
ID=$(python3 -c "import json
with open('.dfx/local/canister_ids.json') as ids:
    print(json.load(ids).get('game_of_life').get('local'))")
    
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "http://127.0.0.1:8000/?canisterId=$ID"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        open "http://127.0.0.1:8000/?canisterId=$ID"
    fi
```



This is heavily inspired from [this](https://rustwasm.github.io/docs/book/game-of-life/implementing.html).