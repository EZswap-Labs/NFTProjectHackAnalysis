# NFT Project Hack Analysis

This is a bug reproduction of the project JPEG

Try running some of the following tasks:

```shell
yarn hardhat test test/Hackjpeg.js
```

1. flashloan weth from bal
2. hack contract receive flashloan weth from bal
3. withdraw weth to eth
4. add_liquidity a half of eth to pETH_ETH_f
5. get hack contract balance of pETH_ETH_f
6. remove_liquidity from pETH_ETH_f
7. get eth from step6 and enter **fallback** to add_liquidity to pETH_ETH_f again
8. remove_liquidity again from pETH_ETH_f
9. exchange pETH to eth from pETH_ETH_f
10. weth to eth
11. payback flashloan to bal
12. send profit to hacker




The point is the **step7**, liquidity can be added due to the failure of the re-entry lock.