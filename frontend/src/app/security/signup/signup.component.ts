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
  public form!: FormGroup;

  constructor(private securityService: SecurityService,
              private router: Router,
              private afAuth: AngularFireAuth) { }

  ngOnInit() {
    this.setupForm();
  }

  private setupForm() {
    this.form = new FormGroup({
      name: new FormControl('', [Validators.required]),
      email: new FormControl('', [Validators.required, Validators.pattern("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")]),
      password: new FormControl('', [Validators.required])
    });
  }

  public async onSubmit() {
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

  public async navigateToLogin() {
    await this.router.navigateByUrl('security/login');
  }

  public authWithGoogle() {
    this.GoogleAuth();
  }

  public GoogleAuth() {
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
