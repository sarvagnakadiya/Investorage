// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <=0.8.15;

import {MarketAPI} from "./MarketAPI.sol";
import {CommonTypes} from "./CommonTypes.sol";
import {MarketTypes} from "./MarketTypes.sol";

contract FilecoinMarketMockTest {
    address owner; // us as NCS Owner(contract Owner)

    uint256 planIdCounter; // Id counter for Plan details
    uint256[] public planIdArray; // Id array for Plan details

    uint256[] emptyPlanCells; //empth cell for plans array

    constructor() {
        owner = msg.sender;
    }

    /// @notice struck for User details
    struct userDetails {
        string name;
        string emailId;
        uint256 mobileNumber;
        string userImage;
    }

    /// @notice struck for plan details
    struct planDetails {
        string name;
        uint256 price;
        uint256 timePeriod;
        string planImage;
    }

    /// @notice mapping for handeling User's data (userDataMapping)
    mapping(address => userDetails) public userDataMapping;
    /// @notice mapping for handeling plan's data (planDataMapping)
    mapping(uint256 => planDetails) public planDataMapping;

    /// @notice mapping for user to plan (which user is subscribed to which plan)
    mapping(address => uint256[]) public userToPlanMapping;

    /// @notice mapping to check user's plan is active or not
    mapping(address => mapping(uint256 => bool)) public isUserPlanActive;

    /// @notice mapping for user's stake
    mapping(address => uint256) public stakeMapping;

    mapping(uint64 => address) public dealIdToAddressMapping;

    ///@notice Function to add user. (signUp) (adding user's data to blockchain)
    function addUser(
        string memory _name,
        string memory _emailId,
        uint256 _mobileNumber,
        string memory _userImage
    ) public {
        userDetails memory user = userDetails(
            _name,
            _emailId,
            _mobileNumber,
            _userImage
        );
        userDataMapping[msg.sender] = user;
    }

    ///@notice Function to get User Details
    function getUserDetails(address _userId)
        public
        view
        returns (userDetails memory)
    {
        return userDataMapping[_userId];
    }

    ///@notice function to delete user(used to delete your OWN account)
    function deleteUser() public {
        delete userDataMapping[msg.sender];
    }

    /// @notice Function to edit users' name
    function editUserName(string memory _name) public {
        userDetails memory user = userDataMapping[msg.sender];
        user.name = _name;
        userDataMapping[msg.sender] = user;
    }

    /// @notice Function to edit users' email
    function editUserEmail(string memory _emailId) public {
        userDetails memory user = userDataMapping[msg.sender];
        user.emailId = _emailId;
        userDataMapping[msg.sender] = user;
    }

    /// @notice Function to edit users' mobileNumber
    function editUserMobileNumber(uint256 _mobileNumber) public {
        userDetails memory user = userDataMapping[msg.sender];
        user.mobileNumber = _mobileNumber;
        userDataMapping[msg.sender] = user;
    }

    /// @notice Function to edit users' Image
    function editUserImage(string memory _userImage) public {
        userDetails memory user = userDataMapping[msg.sender];
        user.userImage = _userImage;
        userDataMapping[msg.sender] = user;
    }

    ///@notice Function to Add Plan
    function addPlan(
        string memory _name,
        uint256 _price,
        uint256 _timePeriod,
        string memory _planImage
    ) public {
        require(msg.sender == owner, "only owner can add plans");
        if (emptyPlanCells.length != 0) {
            planIdCounter = emptyPlanCells[emptyPlanCells.length - 1];
            emptyPlanCells.pop();
        } else {
            planIdCounter = planIdArray.length;
            planIdCounter++;
            planIdArray.push(planIdCounter);
        }
        planDetails memory plan = planDetails(
            _name,
            _price,
            _timePeriod,
            _planImage
        );
        planDataMapping[planIdCounter] = plan;
    }

    ///@notice function to delete plan
    function deletePlan(uint256 _planId) public {
        emptyPlanCells.push(_planId);
        planDetails memory plan = planDetails("", 0, 0, "");
        planDataMapping[_planId] = plan;
    }

    /// @notice Function to count number of plans
    function countPlan() public view returns (uint256) {
        return planIdArray.length;
    }

    ///@notice function to get plan details
    function getPlanDetails(uint256 _planId)
        public
        view
        returns (planDetails memory)
    {
        return planDataMapping[_planId];
    }

    /// @notice function to subscribe to any plan
    function subscribe(address _userId, uint256 _planId) public payable {
        uint256 planPrice = planDataMapping[_planId].price;
        require(msg.value >= planPrice, "please provide proper value");
        stakeMapping[msg.sender] += msg.value;
        isUserPlanActive[_userId][_planId] = true;
        userToPlanMapping[_userId].push(_planId);
    }

    // function planPrice(uint256 _planId) public view returns(uint) {
    //     return planDataMapping[_planId].price;
    // }

    /// @notice function to show user's subscribed plans
    function showUserPlans(address _userId)
        public
        view
        returns (uint256[] memory)
    {
        return userToPlanMapping[_userId];
    }

    ///@notice function to deActivate any plan
    function deActivate(address _userId, uint256 _planId) public {
        isUserPlanActive[_userId][_planId] = false;
    }

    function showUserActivePlans(address _userId, uint256 _planId)
        public
        view
        returns (bool)
    {
        return isUserPlanActive[_userId][_planId];
    }

    function addDealAndAddress(uint64 _dealId, address _marketApiAddress)
        public
    {
        require(msg.sender == owner, "only owner");
        dealIdToAddressMapping[_dealId] = _marketApiAddress;
    }

    function market_withdraw_balance_test(uint64 _dealId)
        public
        returns (MarketTypes.WithdrawBalanceReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        string memory addr = "t01113";
        MarketTypes.WithdrawBalanceParams memory params = MarketTypes
            .WithdrawBalanceParams(addr, 1);

        MarketTypes.WithdrawBalanceReturn memory response = marketApiInstance
            .withdraw_balance(params);
        return response;
    }

    function market_add_balance_test(uint64 _dealId) public {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        string memory addr = "t01113";
        MarketTypes.AddBalanceParams memory params = MarketTypes
            .AddBalanceParams(addr);

        marketApiInstance.add_balance(params);
    }

    function get_balance_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetBalanceReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        string memory params = "t01113";

        MarketTypes.GetBalanceReturn memory response = marketApiInstance
            .get_balance(params);
        return response;
    }

    function get_deal_data_commitment_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealDataCommitmentReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealDataCommitmentParams memory params = MarketTypes
            .GetDealDataCommitmentParams(_dealId);

        MarketTypes.GetDealDataCommitmentReturn
            memory response = marketApiInstance.get_deal_data_commitment(
                params
            );
        return response;
    }

    function get_deal_client_test(uint64 _dealId)
        public
        view
        returns (string memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealClientParams memory params = MarketTypes
            .GetDealClientParams(_dealId);

        MarketTypes.GetDealClientReturn memory response = marketApiInstance
            .get_deal_client(params);
        return response.client;
    }

    function get_deal_provider_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealProviderReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealProviderParams memory params = MarketTypes
            .GetDealProviderParams(_dealId);

        MarketTypes.GetDealProviderReturn memory response = marketApiInstance
            .get_deal_provider(params);
        return response;
    }

    function get_deal_label_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealLabelReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealLabelParams memory params = MarketTypes
            .GetDealLabelParams(_dealId);

        MarketTypes.GetDealLabelReturn memory response = marketApiInstance
            .get_deal_label(params);
        return response;
    }

    function get_deal_term_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealTermReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealTermParams memory params = MarketTypes
            .GetDealTermParams(_dealId);

        MarketTypes.GetDealTermReturn memory response = marketApiInstance
            .get_deal_term(params);
        return response;
    }

    function get_deal_total_price_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealEpochPriceReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealEpochPriceParams memory params = MarketTypes
            .GetDealEpochPriceParams(_dealId);

        MarketTypes.GetDealEpochPriceReturn memory response = marketApiInstance
            .get_deal_total_price(params);
        return response;
    }

    function get_deal_client_collateral_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealClientCollateralReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealClientCollateralParams memory params = MarketTypes
            .GetDealClientCollateralParams(_dealId);

        MarketTypes.GetDealClientCollateralReturn
            memory response = marketApiInstance.get_deal_client_collateral(
                params
            );
        return response;
    }

    function get_deal_provider_collateral_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealProviderCollateralReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealProviderCollateralParams memory params = MarketTypes
            .GetDealProviderCollateralParams(_dealId);

        MarketTypes.GetDealProviderCollateralReturn
            memory response = marketApiInstance.get_deal_provider_collateral(
                params
            );
        return response;
    }

    function get_deal_verified_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealVerifiedReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealVerifiedParams memory params = MarketTypes
            .GetDealVerifiedParams(_dealId);

        MarketTypes.GetDealVerifiedReturn memory response = marketApiInstance
            .get_deal_verified(params);
        return response;
    }

    function get_deal_activation_test(uint64 _dealId)
        public
        view
        returns (MarketTypes.GetDealActivationReturn memory)
    {
        MarketAPI marketApiInstance = MarketAPI(
            dealIdToAddressMapping[_dealId]
        );

        MarketTypes.GetDealActivationParams memory params = MarketTypes
            .GetDealActivationParams(_dealId);

        MarketTypes.GetDealActivationReturn memory response = marketApiInstance
            .get_deal_activation(params);
        return response;
    }
}
