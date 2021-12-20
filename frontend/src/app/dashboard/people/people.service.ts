import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {PersonModel} from "./person.model";
import {environment} from "../../../environments/environment";

@Injectable({
  providedIn: 'root'
})
export class PeopleService {

  constructor(private http: HttpClient) { }

  public getPeople(): Promise<Array<PersonModel>> {
    return this.http.get<Array<PersonModel>>(environment.api + '/People/Get').toPromise();
  }
}
