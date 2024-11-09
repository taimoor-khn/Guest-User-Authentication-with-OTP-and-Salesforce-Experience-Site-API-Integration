import { LightningElement, track } from 'lwc';
import checkAccountExists from '@salesforce/apex/bitStreamMainPageController.checkAccountExists';
import verifyOTP from '@salesforce/apex/bitStreamMainPageController.verifyOtp';
import LightningAlert from 'lightning/alert';
export default class MainPage extends LightningElement {
    @track isModalOpen = false;
    @track theNameDivOpen = false;
    @track theOTPDivOpen = false;
    handleClick() {
        this.isModalOpen = true;
        this.theNameDivOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.theNameDivOpen = false;
        this.theOTPDivOpen = false;
    }

    @track accountName = '';
    @track otpValue = '';
    @track errorMessage = '';

    handleInputChange(event) {

      

        this.accountName = event.target.value;
    }

    handleInputOTPChange(event) {
       

        this.otpValue = event.target.value;
    }

    handleSubmit() {
          if (this.accountName == null || this.accountName=='') {
            LightningAlert.open({
                message: 'Input Field Cannot be Null',
                theme: 'error', // a red theme intended for error states
                label: 'Error!', // this is the header text
            });
            return;
        }
        checkAccountExists({ userId: this.accountName })
            .then((result) => {
                console.log('Response from the Account------' + result);
                if (result) {
                    this.theNameDivOpen = false;
                    this.theOTPDivOpen = true;
                   // LightningAlert.open({
                   //     message: 'Account Found and Email OPT have been sent to your Email',
                    //    theme: 'success', // a red theme intended for error states
                     //   label: 'Success!', // this is the header text
                  //  });
                    //   this.dispatchEvent(new CustomEvent('otpsent', { detail: this.accountName }));
                } else {

                    LightningAlert.open({
                        message: 'Account Not Found',
                        theme: 'error', // a red theme intended for error states
                        label: 'Error!', // this is the header text
                    });



                    // this.errorMessage = 'Account not found.';
                }
            })
            .catch((error) => {
                LightningAlert.open({
                    message: 'Error: ' + error.body.message,
                    theme: 'error', // a red theme intended for error states
                    label: 'Error!', // this is the header text
                });

            });
    }

    handleSubmitOTP() {
 if (this.otpValue== null || this.otpValue=='') {
            LightningAlert.open({
                message: 'Input Field Cannot be Null',
                theme: 'error', // a red theme intended for error states
                label: 'Error!', // this is the header text
            });
            return;
        }
        verifyOTP({ userId: this.accountName, enteredOtp: this.otpValue })
            .then((result) => {
                console.log('Response from verifying otp------');
                if (result) {
                    LightningAlert.open({
                        message: 'Success: ' + result,
                        theme: 'success', // a red theme intended for error states
                        label: 'Success!', // this is the header text
                    });
                    //    this.theNameDivOpen = false;
                    //  this.theOTPDivOpen=true;
                    //   this.dispatchEvent(new CustomEvent('otpsent', { detail: this.accountName }));
                } else {
                     LightningAlert.open({
                    message: 'Wrong OTP',
                    theme: 'error', // a red theme intended for error states
                    label: 'Error!', // this is the header text
                });
                    // this.errorMessage = 'Account not found.';
                }
            })
            .catch((error) => {
                LightningAlert.open({
                    message: 'Error: ' + error.body.message,
                    theme: 'error', // a red theme intended for error states
                    label: 'Error!', // this is the header text
                });
                //this.errorMessage = 'Error: ' + error.body.message;
            });
    }
}
