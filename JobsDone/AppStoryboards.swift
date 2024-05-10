//
//  AppStoryboards.swift
//  Workshop2u
//
//  Created by Waqas Ali on 11/20/16.
//  Copyright © 2016 Dinosoftlabs. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    //MARK:- Generic Public/Instance Methods
    
    func loadViewController(withIdentifier identifier: viewControllers) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
  
    //MARK:- Class Methods to load Storyboards
    
    class func storyBoard(withName name: storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue , bundle: Bundle.main)
    }
    
    class func storyBoard(withTextName name:String) -> UIStoryboard {
        return UIStoryboard(name: name , bundle: Bundle.main)
    }
    
}

enum storyboards : String {
    
    //All Storyboards
    case Main = "Main"
    case SignUp = "SignUp"
    case Home = "Home"
    case Menu = "Menu"
    case Help = "Help"
    case Setting = "Setting"
    case MyJob = "MyJob"
    case Profile = "Profile"
    case Portfolio = "Portfolio"
}

enum viewControllers: String {
    
    //All Controllers
    case signInVC = "SignInVC",
   
    mainScreenVC = "MainScreenVC",
    createFormTVC = "CreateFormTVC",
    editProfileVC = "EditProfileVC",
    addSignUpPhotoTVC = "AddSignUpPhotoTVC",
    exapmleVC = "ExampleViewController",
    privacyVC = "PrivacyPolicyController",
    dashBoardVC = "DashBoardMenuViewController",
    settingsVC = "SettingsListingsController",
    contactUSTVC = "ContactUSTVC",
    privacySettingsVC = "PrivacySettingsViewController",
    membersVC = "MembersViewController",
    likeMembersViewController = "LikeMembersViewController",
    webVC = "WebViewViewController",
   
    
    chatListVC = "ChatListViewController",
    
    memberOrGuestController = "MembersOrGuestsController",
   
    commentVC = "CommentVC",
    signUPTblVC = "SignUpTblVC",
  
    
    
    launchVC = "LaunchVC",
    //2nd Storyboard VCs
    generalSettingTVC = "GeneralSettingTVC",
    deleteAccountTVC = "DeleteAccountTVC",
    changePasswordTVC = "ChangePasswordTVC",
    networkVC = "NetworkVC",
    networksTVC = "NetworksTVC",
    
    messageVC = "MessageVC",
    messageTVC = "MessageTVC",
    composeMessageVC = "ComposeMessageVC",
    chatVC = "ChatVC",
   
    inviteGuestVC = "InviteGuestVC",
    

    FindProfessionalVC = "FindProfessionalVC",
    
    HomeTVC = "HomeTVC",
    IdeaBoardTVC = "IdeaBoardTVC",
    AllMessageVC = "AllMessageVC",
    LeftMenuVC = "LeftMenuVC",
    jobDetailVC = "JobDetailVC",
    applyJobVC = "ApplyJobVC",
    createJobVC = "CreateJobVC",
    
    NotificationVC = "NotificationVC",
    favProfessionalVC = "FavProfessionalVC",
    sendInvitationVC = "SendInvitationVC",
    invitationSuccess = "InvitationSuccess",
    
    helpVC = "HelpVC",
    
    settingRGTab = "SettingRGTab",
    skillsVC = "SkillsVC",
    
    signUpVC = "SignUpVC",
    confirmVC = "ConfirmVC",
    wellcomeVC = "WellcomeVC",
    addPhotoVC = "AddPhotoVC",
    membershipVC = "MembershipVC",
    
    paymentVC = "PaymentVC",
    paypalVC = "PaypalVC",
    cardVC = "CardVC",
    addPaymentVC = "AddPaymentVC",
    
    profileVC = "ProfileVC",
    mainProfileVC = "MainProfileVC",
    
    myJobVC = "MyJobVC",
    jobInvitationVC = "JobInvitationVC",
    jobHistoryVC = "JobHistoryVC",
    
    portfolioVC = "PortfolioVC",
    createPortfolioVC = "CreatePortfolioVC",
    portfolioProfileVC = "PortfolioProfileVC",
    
    addFeedbackVC = "AddFeedbackVC",
    feedbackDetail = "FeedbackDetail",
    feedbackVC = "FeedbackVC",
    
    applicantsVC = "ApplicantsVC",
    forgotPassVC = "ForgotPassVC",
    
    imageVC = "ImageVC",
    
    
z}

