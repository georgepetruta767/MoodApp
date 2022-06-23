import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {environment} from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ResultService {

  constructor(private http: HttpClient) { }

  public getBarChartOptions(category: string, type: string, userId: string): Promise<any> {
    return this.http.get(`${environment.resultsApi}/get-bar-grade/${category}/${type}/${userId}`).toPromise();
  }

  public getScatterChartOptions(column1: string, column2: string, userId: string): Promise<any> {
    return this.http.get(`${environment.resultsApi}/get-scatter/${column1}/${column2}/${userId}`).toPromise();
  }

  public getLineChartOptions(year: number, month: number, day: number, userId: string): Promise<any> {
    return this.http.get(`${environment.resultsApi}/get-moving-average/${year}/${month}/${day}/${userId}`).toPromise();
  }

  public getPieChartOptions(top: boolean, nrPeople: number, userId: string): Promise<any> {
    return this.http.get(`${environment.resultsApi}/get-top-bottom-friends/${top}/${nrPeople}/${userId}`).toPromise();
  }

  public getGeoChartOptions(userId: string): Promise<any> {
    return this.http.get(`${environment.resultsApi}/geo-scatter/grade/${userId}`).toPromise();
  }

  async getExtendedBarChartOptions(type: string, userId: string): Promise<any> {
    return this.http.get(`${environment.resultsApi}/bar-extended/${type}/${userId}`).toPromise();
  }
}
