import { Injectable } from '@angular/core';
import {UserModel} from './login/user.model';
import {HttpClient} from '@angular/common/http';
import {environment} from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class SecurityService {

  constructor(private http: HttpClient) { }

  public getLoginResult(user: UserModel): Promise<string> {
    return this.http.post(environment.api + '/Account/CheckLogin', user, {responseType: 'text'}).toPromise();
  }
}
