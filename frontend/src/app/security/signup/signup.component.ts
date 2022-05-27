import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {SecurityService} from '../../dashboard/common/services/security.service';
import {Router} from '@angular/router';
import {PopoverController} from '@ionic/angular';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss'],
})
export class SignupComponent implements OnInit {
  public isSubmitted = false;

  public form!: FormGroup;

  constructor(private securityService: SecurityService,
              private popoverController: PopoverController,
              private router: Router) { }

  public get errorControl() {
    return this.form.controls;
  }

  public ionViewWillEnter() {
    this.form.reset();
  }

  public ngOnInit() {
    this.setupForm();
  }

  public async onSubmit() {
    console.log(this.form);

    this.isSubmitted = true;
    if(this.form.valid) {
      await this.securityService.signUp({
        firstName: this.form.controls.firstName.value,
        lastName: this.form.controls.lastName.value,
        email: this.form.controls.email.value,
        password: this.form.controls.password.value
      }).then(() => {
        this.router.navigateByUrl('security/login');
      });
    }
  }

  private matchingPasswords(passwordKey: string, confirmPasswordKey: string) {
    return (group: FormGroup): {[key: string]: any} => {
      const password = group.controls[passwordKey];
      const confirmPassword = group.controls[confirmPasswordKey];

      if (password.value !== confirmPassword.value) {
        return {
          mismatchedPasswords: true
        };
      }
    };
  }

  public async navigateToLogin() {
    await this.router.navigateByUrl('security/login');
  }

  public googleAuthentication() {
    //return this.AuthLogin(new GoogleAuthProvider());
  }

  public AuthLogin(provider) {
    /*return this.afAuth
      .signInWithPopup(provider)
      .then(async result => {
        const tok = await result.user.getIdToken(true);
        await this.securityService.googleSignIn({
          provider: result.credential.providerId,
          idToken: tok
        });

      })
      .catch((error) => {
        console.log(error);
      });*/
  }

  private setupForm() {
    this.form = new FormGroup({
      firstName: new FormControl('', [Validators.required]),
      lastName: new FormControl('', [Validators.required]),
      email: new FormControl('', [Validators.required, Validators.pattern('^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$')]),
      password: new FormControl('', [Validators.required,
        Validators.pattern('(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&].{7,}')]),
      confirmPassword: new FormControl('', [Validators.required,
        Validators.pattern('(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&].{7,}')])
    }, {validators: this.matchingPasswords('password', 'confirmPassword')});
  }
}
