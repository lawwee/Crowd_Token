// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "./Extras/tokenInterface.sol";
import "./Extras/context.sol";

contract TokenERC20 is IERC20, Context {

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    address private admin;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        admin = msg.sender;
        uint256 totalSupply_ = 1000;
        _mint(admin, totalSupply_);
    }

    function name() public view returns(string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function decimals() public pure returns(uint256) {
        return 18;
    }

    function totalSupply() public view returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns(uint256) {
        return _balances[account];
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {}

    function _afterTokenTransfer(address from, address to, uint256 amount) internal {}

    function allowance(address owner, address spender) public view returns(uint256) {
        return _allowances[owner][spender];
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _transfer(address from, address to, uint256 _amount) internal {
        require(from != address(0), "ERC20: transfer from zero address");
        require(to != address(0), "ERC20: transfer to zero address");
        uint256 amount = _amount;

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer exceeds amount balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);

    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from zero address");
        require(spender != address(0), "ERC20: approve to zero address");

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        // uint256 amount = _amount * 10 ** decimals();
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function transfer(address to, uint256 amount) public returns(bool) {
        address owner = _msgSender();
        require(owner == msg.sender, "Transfer: Not authorized to call this function");
        _transfer(owner, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns(bool) {
        address owner = _msgSender();
        require(owner == msg.sender, "Transfer: Not authorized to call this function");
        _approve(owner, spender, amount);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns(bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {
        address owner = _msgSender();
        require(owner == msg.sender, "Allowance: You do not have access to this function");
        uint256 amount = addedValue;
        _approve(owner, spender, allowance(owner, spender) + amount);

        return true;
    }

    function decreaseAllowance(address spender, uint256 minusValue) public returns(bool) {
        address owner = _msgSender();
        require(owner == msg.sender, "Allowance: You do not have access to this function");
        uint256 currentAllowance = allowance(owner, spender);
        uint256 amount = minusValue;
        require(currentAllowance >= amount, "ERC20: decrease allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - amount);
        }

        return true;
    }

    function mint(address account, uint256 amount) external returns(bool) {
        _mint(account, amount);
        return true;
    }

    function burn(uint256 amount) public {
        address owner = _msgSender();
        require(owner == msg.sender, "Burn: account does not belong to you");
        _burn(owner, amount);
    }

}