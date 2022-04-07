import { Injectable } from '@angular/core';
import {UserModel} from './login/user.model';
import {HttpClient} from '@angular/common/http';
import {environment} from '../../environments/environment';
import { GoogleAuthProvider } from 'firebase/auth';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import {ExternalSignUpModel} from "./login/external-sign-up.model";

@Injectable({
  providedIn: 'root'
})
export class SecurityService {

  constructor(private http: HttpClient) {}

  public getLoginResult(user: UserModel): Promise<string> {
    return this.http.post(`${environment.api}/Account/CheckLogin`, user, {responseType: 'text'}).toPromise();
  }

  public signUp(user: UserModel): Promise<any> {
    return this.http.post(`${environment.api}/Account/SignUp`, user, {responseType: 'text'}).toPromise();
  }

  public googleSignIn(externalSignUpModel: ExternalSignUpModel): Promise<any> {
    return this.http.post(`${environment.api}/Account/ExternalSignUp`, externalSignUpModel, { responseType: 'text' }).toPromise();
  }
}

