import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class IdentityService {

  constructor() { }

  public storeAuthToken(token: string) {
    sessionStorage.setItem("bearerToken", token);
  }

  public get isLoggedIn() {
    return sessionStorage.getItem("bearerToken");
  }
}
