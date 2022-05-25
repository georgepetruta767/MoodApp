import {Component, OnInit} from '@angular/core';

import * as echarts from 'echarts';
import {ResultService} from './result.service';
import {SecurityService} from '../common/services/security.service';

type EChartsOption = echarts.EChartsOption;

@Component({
  selector: 'app-results',
  templateUrl: './results.component.html',
  styleUrls: ['./results.component.scss'],
})
export class ResultsComponent implements OnInit {
  public meanGradeOverSeasonChart: EChartsOption;

  public userId: string;

  constructor(private resultsService: ResultService,
              private accountService: SecurityService) { }

  public async ngOnInit() {
    this.userId = await this.accountService.getUserId();
    this.meanGradeOverSeasonChart = await this.resultsService.getMeanGradePerSeasonValues(this.userId);
    console.log(this.meanGradeOverSeasonChart)
  }
}
