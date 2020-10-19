# Mobile Consents SDK

# Installation


# Using the SDK

## Initializing

```swift 
let serverURL = URL(string: "{address_of_the_server_to_send_consent}")!
let mobileConsentsSDK = MobileConsents(withBaseURL: serverURL)
```
## Getting Consent Solution

```swift 
mobileConsentsSDK.fetchConsentSolution(forUniversalConsentSolutionId: "consent solution identifier", completion: { result in
	switch result {
	case .success(let consentSolution):
	  /* here you can maek use of fetched ConsentSolution object */
	case .failure(let error):
	  /* here you can handle error from fetching te content solution */
	}
}) 

/* ConsentSolution object structure */

struct  ConsentSolution {
  let  id: String
  let  versionId: String
  let  consentItems: [ConsentItem]
}

struct  ConsentItem {
  let  id: String
  let  translations: [ConsentTranslation]
}

struct  ConsentTranslation {
  let  language: String
  let  shortText: String
  let  longText: String
}
```

## Sending Consent to server
If you want to send consent to the server, first you have to create `Consent` object which structure looks like this:
```swift
var consent = Consent(consentSolutionId: "consentSolution.id", consentSolutionVersionId: "consentSolution.versionId")

/* if you want your consent to have a custom data you can add it as a last parametr */
let customData = ["email": "test@test.com", "device_id": "test_device_id"]
var consent = Consent(consentSolutionId: "consentSolution.id", consentSolutionVersionId: "consentSolution.versionId" customData: customData)

```
Then you have to add processing purposes which contains a given consents

```swift
/* given consents are included in main consent object as Purposes objects which you can add to Consent object using `addProcessingPurpose` function */

let purpose = Purpose(consentItemId: "consentItem.id", consentGiven: {true / false}, language: "en")
consent.addProcessingPurpose(purpose)

```
After setting up the Consent object you are ready to send it to the server
```swift
mobileConsentsSDK.postConsent(consent) { error in
  /* if error is nil it means that post succeeded */
}
```
## Getting lacally saved consents data
```swift
let savedData:[SavedConsent] = mobileConsentsSDK.getSavedConsents()
```
SavedConsent object structure
```swift
struct  SavedConsent {
  let  consentItemId: String
  let  consentGiven: Bool
}
```

## Canceling last save request
```swift
mobileConsentsSDK.cancel()
```
