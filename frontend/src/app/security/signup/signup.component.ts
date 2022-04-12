import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {SecurityService} from "../security.service";
import {Router} from "@angular/router";
import {GoogleAuthProvider} from "firebase/auth";
import {AngularFireAuth} from "@angular/fire/compat/auth";

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss'],
})
export class SignupComponent implements OnInit {
  public ionViewWillEnter() {
    this.form.reset();
  }

  public isSubmitted = false;

  public form!: FormGroup;

  constructor(private securityService: SecurityService,
              private router: Router,
              private afAuth: AngularFireAuth) { }

  ngOnInit() {
    this.setupForm();
  }

  get errorControl() {
    return this.form.controls;
  }

  private setupForm() {
    this.form = new FormGroup({
      name: new FormControl('', [Validators.required]),
      email: new FormControl('', [Validators.required, Validators.pattern("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")]),
      password: new FormControl('', [Validators.required,
        Validators.pattern('(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&].{7,}')]),
      confirmPassword: new FormControl('', [Validators.required,
        Validators.pattern('(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&].{7,}')])
    });
  }

  public async onSubmit() {
    this.isSubmitted = true;
    if(this.form.valid) {
      await this.securityService.signUp({
        userName: this.form.controls.name.value,
        email: this.form.controls.email.value,
        password: this.form.controls.password.value
      }).then(() => {
        this.router.navigateByUrl('security/login');
      })
    }
  }

  public confirmedPasswordValidator(controlName: string, matchingControlName: string) {
    return (formGroup: FormGroup) => {
      const control = formGroup.controls[controlName];
      const matchingControl = formGroup.controls[matchingControlName];

      if (matchingControl.errors && !matchingControl.errors.mustMatch) {
        // return if another validator has already found an error on the matchingControl
        return;
      }

      // set error on matchingControl if validation fails
      if (control.value !== matchingControl.value) {
        matchingControl.setErrors({ mustMatch: true });
      } else {
        matchingControl.setErrors(null);
      }
    }
  }

  public async navigateToLogin() {
    await this.router.navigateByUrl('security/login');
  }

  public googleAuthentication() {
    return this.AuthLogin(new GoogleAuthProvider());
  }

  public AuthLogin(provider) {
    return this.afAuth
      .signInWithPopup(provider)
      .then(async result => {
        const tok = await result.user.getIdToken(true);
        await this.securityService.googleSignIn({
          provider: result.credential.providerId,
          idToken: tok
        })

      })
      .catch((error) => {
        console.log(error);
      });
  }
}
