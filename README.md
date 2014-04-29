Alerts
======

UIAlertView simple apis.

## Short code
      [[UIAlertView alertWithMessage:@"some message"] show]

## Event Handling
      [[[[UIAlertView alertWithMessage:@"some message"] cancel:^{
        // ...
      }] ok:^{
        // ...
      }] show]

## Convinience methods

      [UIAlertView alertWithConfirmMessage:@"some message"];
      [UIAlertView alertWithDebugMessage:@"some message"];
      [UIAlertView alertWithErrorMessage:@"some message"];
      [UIAlertView alertWithInfoMessage:@"some message"];
      [UIAlertView alertWithWarningMessage:@"some message"];

## Localize
  Add "Alerts.strings" to your project.
