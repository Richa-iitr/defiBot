//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEulerMarkets {
	function enterMarket(uint256 subAccountId, address newMarket) external;

	function getEnteredMarkets(address account)
		external
		view
		returns (address[] memory);

	function exitMarket(uint256 subAccountId, address oldMarket) external;

	function underlyingToEToken(address underlying)
		external
		view
		returns (address);

	function underlyingToDToken(address underlying)
		external
		view
		returns (address);
}

interface IEulerEToken {
	function deposit(uint256 subAccountId, uint256 amount) external;

	function withdraw(uint256 subAccountId, uint256 amount) external;

	function decimals() external view returns (uint8);

	function mint(uint256 subAccountId, uint256 amount) external;

	function burn(uint256 subAccountId, uint256 amount) external;

	function balanceOf(address account) external view returns (uint256);

	function balanceOfUnderlying(address account) external view returns (uint);

	function transferFrom(address from, address to, uint amount) external returns (bool);

	function approve(address spender, uint256 amount) external returns (bool);
}

interface IEulerDToken {
	function underlyingToDToken(address underlying)
		external
		view
		returns (address);

	function decimals() external view returns (uint8);

	function borrow(uint256 subAccountId, uint256 amount) external;

	function repay(uint256 subAccountId, uint256 amount) external;

	function balanceOf(address account) external view returns (uint256);

	function transferFrom(address from, address to, uint amount) external returns (bool);

	function approveDebt(
		uint256 subAccountId,
		address spender,
		uint256 amount
	) external returns (bool);
}
interface TokenInterface {
    function approve(address, uint256) external;
    function transfer(address, uint) external;
    function transferFrom(address, address, uint) external;
    function deposit() external payable;
    function withdraw(uint) external;
    function balanceOf(address) external view returns (uint);
    function decimals() external view returns (uint);
    function totalSupply() external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint256);
}
contract Bot {
    address public owner;
    mapping(address => bool) public approvedUsers;

    constructor() {
        owner = msg.sender;
    }

    // Approve a user
    function approveUser(address user) external {
        require(msg.sender == owner, "Only owner can approve users");
        approvedUsers[user] = true;
    }

    function deposit(
		uint256 subAccount,
		address token,
		uint256 amt,
		bool enableCollateral
	)
		external
		payable
	{
		uint256 _amt = getUint(getId, amt);

		bool isEth = token == ethAddr;
		address _token = isEth ? wethAddr : token;

		TokenInterface tokenContract = TokenInterface(_token);

		if (isEth) {
			_amt = _amt == uint256(-1) ? address(this).balance : _amt;
			;
		} else {
			_amt = _amt == uint256(-1)
				? tokenContract.balanceOf(address(this))
				: _amt;
		}

		approve(tokenContract, EULER_MAINNET, _amt);

		IEulerEToken eToken = IEulerEToken(markets.underlyingToEToken(_token));
		eToken.deposit(subAccount, _amt);

		if (enableCollateral) {
			markets.enterMarket(subAccount, _token);
		}
	
	}

}