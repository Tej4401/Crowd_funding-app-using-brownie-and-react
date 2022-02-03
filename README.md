# Crowd Funding

It is a small scale app built using brownie and react which enables users to donate various crypto tokens to a contract. 
The app is only for learning purposes and the contracted is deployed on kovan testnet of ethereum blockchain.

## Installing brownie
https://eth-brownie.readthedocs.io/en/stable/install.html

## Cloning the repository

```bash
git clone  https://github.com/Tej4401/Crowd_funding-app-using-brownie-and-react.git
```

## Migrating to the downloaded directory

```bash
cd Crowd_funding-app-using-brownie-and-react
```

## Configuring .env
You need to add the relevant variables in the .env file

# Adding Private Key
You can get the private key from your browser wallet like metamask.

# Adding infura key
You can make an account on infura and generate a key.

## Compiling Contracts

```bash
brownie compile
```

## Deploying Contracts to Kovan testnet

```bash
brownie run scripts/deploy.py --network kovan
```

## Testing frontend
We need to migrate to frontend_directory and start the server.
Also we need to install the dependencies.

```bash
cd front_end
npm install
npm start
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
