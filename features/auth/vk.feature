Feature: Sing in vk
  Scenario: Use vk account for registration
    When I click vk icon, Site redirect me into vk app
    And I Confirmed the app
    Then I must write my email
    And confirm the email for registration
    Then I am a site user
    because I give my email and confirm for email