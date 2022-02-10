import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {PersonModel} from "../models/person.model";
import {environment} from "../../../../environments/environment";

@Injectable({
  providedIn: 'root'
})
export class PeopleService {

  constructor(private http: HttpClient) { }

  public getPeople(): Promise<Array<PersonModel>> {
    return this.http.get<Array<PersonModel>>(environment.api + '/People/Get',{
      headers: new HttpHeaders({
        "Authorization": `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public addPerson(personModel: PersonModel): Promise<any> {
    return this.http.post(`${environment.api}/People/Add`, personModel, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }
}
