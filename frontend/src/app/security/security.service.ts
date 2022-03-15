import { Injectable } from '@angular/core';
import {UserModel} from './login/user.model';
import {HttpClient} from '@angular/common/http';
import {environment} from '../../environments/environment';
import { GoogleAuthProvider } from 'firebase/auth';
import { AngularFireAuth } from '@angular/fire/compat/auth';

@Injectable({
  providedIn: 'root'
})
export class SecurityService {

  constructor(private http: HttpClient,
              private afAuth: AngularFireAuth) { }

  public getLoginResult(user: UserModel): Promise<string> {
    return this.http.post(environment.api + '/Account/CheckLogin', user, {responseType: 'text'}).toPromise();
  }

  public signUp(user: UserModel) : Promise<any> {
    return this.http.post(environment.api + '/Account/SignUp', user, {responseType: 'text'}).toPromise();
  }

  GoogleAuth() {
    return this.AuthLogin(new GoogleAuthProvider());
  }
  // Auth logic to run auth providers
  AuthLogin(provider) {
    return this.afAuth
      .signInWithPopup(provider)
      .then((result) => {
        console.log(result);
      })
      .catch((error) => {
        console.log(error);
      });
  }
}
