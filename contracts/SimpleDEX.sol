// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleDEX {
    IERC20 public tokenA;
    IERC20 public tokenB;
    address public owner;

    uint256 public reserveA;
    uint256 public reserveB;

    event LiquidityAdded(uint256 amountA, uint256 amountB);
    event LiquidityRemoved(uint256 amountA, uint256 amountB);
    event SwappedAforB(address user, uint256 amountAIn, uint256 amountBOut);
    event SwappedBforA(address user, uint256 amountBIn, uint256 amountAOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        owner = msg.sender;
    }

    function addLiquidity(uint256 amountA, uint256 amountB) public {
        require(msg.sender == owner, "Only owner");
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Transfer failed A");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Transfer failed B");

        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(amountA, amountB);
    }

    function removeLiquidity(uint256 amountA, uint256 amountB) public {
        require(msg.sender == owner, "Only owner");
        require(amountA <= reserveA && amountB <= reserveB, "Not enough reserves");

        reserveA -= amountA;
        reserveB -= amountB;

        require(tokenA.transfer(msg.sender, amountA), "Transfer failed A");
        require(tokenB.transfer(msg.sender, amountB), "Transfer failed B");

        emit LiquidityRemoved(amountA, amountB);
    }

    function swapAforB(uint256 amountAIn) public {
        require(amountAIn > 0, "Amount must be > 0");
        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "Transfer failed A");

        uint256 amountBOut = getAmountOut(amountAIn, reserveA, reserveB);
        require(amountBOut <= reserveB, "Not enough liquidity B");

        reserveA += amountAIn;
        reserveB -= amountBOut;

        require(tokenB.transfer(msg.sender, amountBOut), "Transfer failed B");

        emit SwappedAforB(msg.sender, amountAIn, amountBOut);
    }

    function swapBforA(uint256 amountBIn) public {
        require(amountBIn > 0, "Amount must be > 0");
        require(tokenB.transferFrom(msg.sender, address(this), amountBIn), "Transfer failed B");

        uint256 amountAOut = getAmountOut(amountBIn, reserveB, reserveA);
        require(amountAOut <= reserveA, "Not enough liquidity A");

        reserveB += amountBIn;
        reserveA -= amountAOut;

        require(tokenA.transfer(msg.sender, amountAOut), "Transfer failed A");

        emit SwappedBforA(msg.sender, amountBIn, amountAOut);
    }

    function getPrice(address _token) public view returns (uint256) {
        if (_token == address(tokenA)) {
            return (reserveB * 1e18) / reserveA; // price of 1 A in B
        } else if (_token == address(tokenB)) {
            return (reserveA * 1e18) / reserveB; // price of 1 B in A
        } else {
            return 0;
        }
    }

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal pure returns (uint256) {
        // x + dx, y - dy = xy => dy = (amountIn * reserveOut) / (reserveIn + amountIn)
        return (amountIn * reserveOut) / (reserveIn + amountIn);
    }
}
