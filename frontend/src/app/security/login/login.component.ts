import {Component, OnInit} from '@angular/core';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {SecurityService} from '../../dashboard/common/services/security.service';
import {Router} from '@angular/router';
import {IdentityService} from '../../common/identity.service';
import {ToastController} from '@ionic/angular';
import { GoogleAuth } from '@codetrix-studio/capacitor-google-auth';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  public form!: FormGroup;

  constructor(private securityService: SecurityService,
              private identityService: IdentityService,
              private router: Router,
              private toastController: ToastController) { }

  public async ionViewWillEnter(){
    await this.identityService.removeAuthToken();
    this.form.reset();
  }

  public ngOnInit() {
    this.setupForm();
  }

  public async onSubmit() {
    if (this.form.valid) {
      const bearerToken = await this.securityService.getLoginResult({
        email: this.form.controls.email.value,
        password: this.form.controls.password.value
      }).catch(async (e) => {
        console.log(e);
        await this.presentToast();
      });
      if(bearerToken) {
        this.identityService.storeAuthToken(bearerToken);
        await this.router.navigateByUrl('calendar');
      }
    }
  }

  public async navigateToSignUp() {
    await this.router.navigateByUrl('security/signup');
  }

  public async googleAuthentication() {
    const user = await GoogleAuth.signIn();
    if (user) { console.log(user); }
   // return this.AuthLogin(new GoogleAuthProvider());
  }

  public AuthLogin(provider) {
    /*return this.afAuth
      .signInWithPopup(provider)
      .then(async result => {
        const tok = await result.user.getIdToken(true);
        let bearerToken = await this.securityService.googleSignIn({
          provider: result.credential.providerId,
          idToken: tok
        });

        if(bearerToken) {
          this.identityService.storeAuthToken(bearerToken);
          await this.router.navigateByUrl('calendar');
        }
      })
      .catch((error) => {
        console.log(error);
      });*/
  }

  private setupForm() {
    this.form = new FormGroup({
      email: new FormControl('', [Validators.required, Validators.pattern('^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$')]),
      password: new FormControl('', [Validators.required])
    });
  }

  private async presentToast() {
    const toast = await this.toastController.create({
      message: 'Invalid username or password.',
      duration: 2000
    });
    await toast.present();
  }
}
