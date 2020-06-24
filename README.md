# game_of_life


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

Install the required Node modules (only needed the first time).

```bash
npm install
```

Start the replica, then build and install the canisters.

```bash
dfx start --background
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
ID=$(xxd -u -p canisters/game_of_life/_canister.id)
CRC=$(python2 -c "import crc8;h=crc8.crc8();h.update('$ID'.decode('hex'));print(h.hexdigest())")
xdg-open "http://127.0.0.1:8000/?canisterId=ic:$ID$CRC"
```
This is heavily inspired from [this](https://rustwasm.github.io/docs/book/game-of-life/implementing.html).
