import { Injectable } from '@angular/core';
import {UserModel} from './user-model';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {environment} from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class SecurityService {

  constructor(private http: HttpClient) { }

  public getLoginResult(user: UserModel): Promise<string> {
    //{headers: new HttpHeaders({'Content-Type': 'application/json'})}
    return this.http.post<string>(environment.api + '/Account/CheckLogin', user).toPromise();
  }
}
