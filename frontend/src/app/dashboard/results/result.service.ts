import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {environment} from "../../../environments/environment";

@Injectable({
  providedIn: 'root'
})
export class ResultService {

  constructor(private http: HttpClient) { }

  public getMeanGradePerSeasonValues(): Promise<any> {
    return this.http.get(`${environment.resultsApi}/get-bar-grade/mean`).toPromise();
  }
}
