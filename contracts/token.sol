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
        uint256 totalSupply_ = 1000 * 10 ** decimals();
        _mint(admin, totalSupply_);
    }

    function name() public view returns(string memory) {
        console.log(_name);
        return _name;
    }

    function symbol() public view returns(string memory) {
        console.log(_symbol);
        return _symbol;
    }

    function decimals() public pure returns(uint256) {
        return 18;
    }

    function totalSupply() public view returns(uint256) {
        console.log(_totalSupply);
        return _totalSupply;
    }

    function balanceOf(address account) public view returns(uint256) {
        console.log("Owner balance is:", _balances[account]);
        return _balances[account];
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {}

    function _afterTokenTransfer(address from, address to, uint256 amount) internal {}

    function allowance(address owner, address spender) public view returns(uint256) {
        console.log("Allowance balance for %s against %s is:", owner, spender, _allowances[owner][spender]);
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
        uint256 amount = _amount * 10 ** decimals();

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
                _approve(owner, spender, currentAllowance - (amount * 10 ** decimals()));
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
        console.log("Transfer from %s to %s with %d", owner, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns(bool) {
        address owner = _msgSender();
        require(owner == msg.sender, "Transfer: Not authorized to call this function");
        _approve(owner, spender, (amount * 10 ** decimals()));
        console.log("%s sent %s an allowance of %d", owner, spender, amount * 10 ** decimals());

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
        uint256 amount = addedValue * 10 ** decimals();
        _approve(owner, spender, allowance(owner, spender) + amount);
        console.log("%s increased allowance of %s by %d", owner, spender, amount);
        return true;
    }

    function decreaseAllowance(address spender, uint256 minusValue) public returns(bool) {
        address owner = _msgSender();
        require(owner == msg.sender, "Allowance: You do not have access to this function");
        uint256 currentAllowance = allowance(owner, spender);
        uint256 amount = minusValue * 10 ** decimals();
        require(currentAllowance >= amount, "ERC20: decrease allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - amount);
        }
        console.log("%s reduced allowance of %s by %d", owner, spender, amount);
        return true;
    }

    function mint(uint256 amount) external returns(bool) {
        require(admin == msg.sender, "Mint: Not authorized to call this function");
        _mint(admin, (amount * 10 ** decimals()));
        return true;
    }

    function burn(uint256 amount) public {
        address owner = _msgSender();
        require(owner == msg.sender, "Burn: account does not belong to you");
        _burn(owner, (amount * 10 ** decimals()));
    }

}