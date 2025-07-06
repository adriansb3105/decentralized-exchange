// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v5.3.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}


// File contracts/SimpleDEX.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity 0.8.28;
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
