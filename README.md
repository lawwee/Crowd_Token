# Crowd Token

Technologies Used:

  * Solidity
  * Javascript
  * Hardhat
  * Remix IDE
  * Alchemy
  * Metamask

Crowd Token is a project that demonstrates the functionalities of a standard Crowdsale, also known as an ICO.

The address of the ERC20 Token Smart Contract is **0x9ae38f8a12B9e34E0939A44809320D085d341802**, the address of the Crowd Token Smart Contract is **0x04Fe4E791Bdc65662B918abb322De15fe3ec2dE6**, they can both be found on the Goerli Testnet of the Ethereum network.

The main purpose of the project is to allow interested individuals be able to buy the tokens associated with the project that is being worked on.
A lot of research had to be done in regards to the project due to the fact that OpenZeppelin no longer supported the crowdsale implementation.

Herein lies the functionalities available to all users on the platform.

There are quite a number of available functions on this project, however, not all would be discussed, the ones most important to the users would be explained and a few others shall also be explained.

The project is a two part system, whereby ERC20 tokens are first created, then the token sale is created and operates on the availability of the created tokens.

**The Token Functions**

 * The **Transfer** Event - is triggered when a transfer of tokens happens between addresses. It takes three parameters namely from, to and amount. The "from" refers to the account from which the token is being transferred, the "to" refers to address that receives the tokens. The "amount" refers to the number of tokens being transferred.

 * The **Approval** Event - It takes three parameters namely owner, spender and value. The "owner" refers to the address that wishes to approve tokens to another address, the "spender" refers to address that receives the approval of tokens. The "value" refers to the number of tokens being set for approval.

 * The **totalSupply()** Function - it returns the total supply of the token.

 * The **balanceOf()** Function - it returns the token balance of an address. It takes in one parameter named address, which repreesents the address of which the request is meant upon.

 * The **allowance()** Function - This function takes in two parameters namely owner and spender. It returns how much token the spender is allowed to spend on behalf of the owner and owner's balance. The "owner" represents the original owner of the tokens, the "spender" represents whom the owner has authorized to spend his/her own tokens his/her behalf.

 * The **transfer()** Function - it allows for whoever is calling the function to transfer an amount of their tokens to another address. It takes in two parameters namely to and amount. The "to" refers to the address that is meant to receive the tokens, while the "amount" refers to the amount of token being transferred.

 * The **approve()** Function - the function takes in two parameters namely spender and amount. (See allowance() for spender). The "amount" refers to the amount of tokens. The function allows whoever calls it to approve a certain amount of tokens so spender can spend said tokens on their behalf.

 * The **transferFrom()** Function - it takes three parameters namely from, to and amount. "from" is the address where the tokens are being sent from, "to" is the address where the tokens are being sent to, and "amount" is the amount of tokens being sent. This function allows whoever calls it be able to send tokens from another address (from) to another address (to). This transaction can only succeed if the caller has been approved beforehand using the approve() function, together with the limit of the allowed tokens.

**The Crowd Sale Functions**

 * The **TokensPurchased** Event - this is triggered when a new set of tokens has been purchased. It takes in four parameters, namely _purchaser_, _beneficiary_, _value_ and _amount_. The "purchaser" refers to the address buying the said amount of tokens, the "beneficiary" is the address set to receive the newly bought tokens, the "value" is the amount of ether(ETH) being sent and the "amount" refers to the quantity of tokens being sent to the beneficiary. 

 * The **TimeExtended** Event - is triggered if the time set for the project to end has been changed to a new one. It has two parameters namely _prevClosingTime_ and _newClosingTime_. As thought, the "prevClosingTime" refers to the original closing time that was set when the project was launched, the "newClosingTime" refers to the new time that has been set for the project to end.

 * The **cap()** Function - simply returns the maximum amount of ether(ETH) to be reached.

 * The **capReached()** Function - tells whether the "cap()" function has been reached or not.

 * The **rate()** Function - returns the current rate of each token.

 * The **weiRaised()** Function - shows the amount of ether(ETH) that has been raised so far.

 * The **isOpen()** Function - tells if the crowdsale has started or not.

 * The **hasClosed()** Function - tells if the crowdsale is closed or not.

 * The **buyTokens()** Function - This takes a single parameter called the _beneficiary_, the function is called when the user chooses to buy an amount of tokens associated with the project, the amount of tokens is given to the "beneficiary", allowing whoever calls the function to buy tokens for either themselves or someone else. The tokens sent is determined by the amount of ether (ETH) sent when called.

 * The **getUserContributions()** Function - this function takes in one parameter called _beneficiary_, which refers to the address that is been submitted for the function request. When called, it returns the amount of ether(ETH) given by the submitted address.

 * The **getCrowdsaleStage()** Function - it allows users view whether the project is in a presale stage or the actual sale stage.

