import { Component, OnInit } from '@angular/core';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {SecurityService} from "../security.service";
import {Router} from "@angular/router";
import {IdentityService} from "../../common/identity.service";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  public form!: FormGroup;

  constructor(private securityService: SecurityService,
              private identityService: IdentityService,
              private router: Router) { }

  ngOnInit() {
    this.setupForm();
  }

  public onSignIn(googleUser) {
    var profile = googleUser.getBasicProfile();
    console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
    console.log('Name: ' + profile.getName());
    console.log('Image URL: ' + profile.getImageUrl());
    console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
  }

  public googleSignUp() {
    /*this.googlePlus.login({}
    ).then(res => {
      console.log(res);
    }).catch(err => console.log(err));*/
  }

  /*public googleSignIn() {
    var profile = googleUser.getBasicProfile();
    console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
    console.log('Name: ' + profile.getName());
    console.log('Image URL: ' + profile.getImageUrl());
    console.log('Email: ' + profile.getEmail());
  }
  public googleLogIn() {

  }*/

  private setupForm() {
    this.form = new FormGroup({
      email: new FormControl('', [Validators.required, Validators.pattern("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")]),
      password: new FormControl('', [Validators.required])
    });
  }

  public async onSubmit() {
    if (this.form.valid) {
      let bearerToken = await this.securityService.getLoginResult({
        email: this.form.controls.email.value,
        password: this.form.controls.password.value
      }).catch(error => {
        console.log(error);
      })
      if(bearerToken) {
        this.identityService.storeAuthToken(bearerToken);
        this.router.navigateByUrl('calendar');
      }
    }
  }

  public async navigateToSignUp() {
    await this.router.navigateByUrl('security/signup');
  }
}
