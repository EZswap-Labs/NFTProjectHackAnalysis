// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface ICurvePool {
    function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount)
        external
        payable
        returns (uint);

    function remove_liquidity(uint256 _burn_amount, uint[2] memory _min_amounts)
        external
        returns (uint[2] memory);

    function balanceOf(address user) external view returns (uint amount);

    function exchange(
        int128 i,
        int128 j,
        uint256 _dx,
        uint256 _min_dy
    ) external payable returns (uint);
}